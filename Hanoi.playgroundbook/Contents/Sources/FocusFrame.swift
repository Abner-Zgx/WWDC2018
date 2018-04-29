//
//  FocusFrame.swift
//  Hanoi
//
//  Created by xiang on 2018/3/24.
//  Copyright © 2018年 xiang. All rights reserved.
//

// Refer to Apple official demo

import Foundation
import ARKit

public class FocusFrame: SCNNode {
    
    // 聚焦框的原始尺寸,单位是米.
    static let size: Float = 0.17
    
    // 聚焦框的线宽,单位是米.
    static let thickness: Float = 0.018
    
    // 当聚焦框关闭状态时的缩放因子,原始尺寸.
    static let scaleForClosedSquare: Float = 0.97
    
    // 当聚焦框打开状态时边的长度
    static let sideLengthForOpenSegments: CGFloat = 0.2
    
    // 开启/关闭动画的时长.
    static let animationDuration = 0.7
    
    static let primaryColor = #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
    
    // 聚焦框填充颜色.
    static let fillColor = #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
    
    // 标识,聚焦框的线段是否处于断开状态.
    private var isOpen = false
    
    // 标识,聚焦框是否处于动画中.
    private var isAnimating = false
    
    // 聚焦框最新的位置.
    private var recentFocusSquarePositions: [float3] = []
    
    // 先前访问过的平面锚点
    private var anchorsOfVisitedPlanes: Set<ARAnchor> = []
    
    // 聚焦框中数组
    private var segments: [FocusFrame.Segment] = []
    
    // 控制其他FocusFrame节点位置的主节点.
    private let positioningNode = SCNNode()
    
    // 用于判断的状态
    public var isPlaneDetected = false
    
    // 节点3种状态
    public enum State {
        case initializing // 初始化
        case featuresDetected(anchorPosition: float3, camera: ARCamera?) // 特征点
        case planeDetected(anchorPosition: float3, planeAnchor: ARPlaneAnchor, camera: ARCamera?) // 平面
    }
    
    // 状态传旨
    public var state: State = .initializing {
        didSet {
            guard state != oldValue else { return } // 保证不是原值
            
            switch state {
            case .initializing:
                displayOnCamera()
                
            case .featuresDetected(let anchorPosition, let camera):
                displayAsOpen(at: anchorPosition, camera: camera)
                
            case .planeDetected(let anchorPosition, let planeAnchor, let camera):
                displayAsClosed(at: anchorPosition, planeAnchor: planeAnchor, camera: camera)
                isPlaneDetected = true
            }
        }
    }
    
    // 根据当前状态,得到聚焦框最新的位置.
    public var lastPosition: float3? {
        switch state {
        case .initializing: return nil
        case .featuresDetected(let anchorPosition, _): return anchorPosition
        case .planeDetected(let anchorPosition, _, _): return anchorPosition
        }
    }
    override public init() {
        super.init()
        opacity = 0.0
        
        /*
         聚焦框包含了下面的八个线段,各个线段可以有单独的动画效果.
             s1  s2
             _   _
         s3 |     | s4
        
         s5 |     | s6
             -   -
             s7  s8
         */
        let s1 = Segment(name: "s1", corner: .topLeft, alignment: .horizontal)
        let s2 = Segment(name: "s2", corner: .topRight, alignment: .horizontal)
        let s3 = Segment(name: "s3", corner: .topRight, alignment: .vertical)
        let s4 = Segment(name: "s4", corner: .topRight, alignment: .vertical)
        let s5 = Segment(name: "s5", corner: .bottomLeft, alignment: .vertical)
        let s6 = Segment(name: "s6", corner: .bottomRight, alignment: .vertical)
        let s7 = Segment(name: "s7", corner: .bottomLeft, alignment: .horizontal)
        let s8 = Segment(name: "s8", corner: .bottomRight, alignment: .horizontal)
        segments = [s1, s2, s3, s4, s5, s6, s7, s8] // 加入数组
        
        let sl: Float = 0.5  // 线段长
        let c: Float = FocusFrame.thickness / 2 //  纠正线段,使其完美对齐.
        s1.simdPosition += float3(-(sl / 2 - c), -(sl - c), 0)
        s2.simdPosition += float3(sl / 2 - c, -(sl - c), 0)
        s3.simdPosition += float3(-sl, -sl / 2, 0)
        s4.simdPosition += float3(sl, -sl / 2, 0)
        s5.simdPosition += float3(-sl, sl / 2, 0)
        s6.simdPosition += float3(sl, sl / 2, 0)
        s7.simdPosition += float3(-(sl / 2 - c), sl - c, 0)
        s8.simdPosition += float3(sl / 2 - c, sl - c, 0)
        
        positioningNode.eulerAngles.x = .pi / 2 // 水平
        positioningNode.simdScale = float3(FocusFrame.size *  FocusFrame.scaleForClosedSquare) // 聚焦框大小调整
        
        for segment in segments {
            positioningNode.addChildNode(segment) // 线条加入主节点
        }
                
        positioningNode.addChildNode(fillPlane) // 填满框加入主节点
        
        // 总是在其它内容上面渲染聚焦框.
        //displayNodeHierarchyOnTop(true)
        
        addChildNode(positioningNode)
        
        // 将聚焦框平行于摄像头显示
        displayOnCamera()
    }
    
    // 完成时聚焦框填满
    private lazy var fillPlane: SCNNode = {
        let correctionFactor = FocusFrame.thickness / 2
        let length = CGFloat(1.0 - FocusFrame.thickness * 2 + correctionFactor)
        
        let plane = SCNPlane(width: length, height: length)
        let node = SCNNode(geometry: plane)
        node.name = "fillPlane"
        node.opacity = 0.0
        
        let material = plane.firstMaterial!
        material.diffuse.contents = FocusFrame.fillColor
        material.isDoubleSided = true
        material.ambient.contents = UIColor.white
        material.lightingModel = .constant
        material.emission.contents = FocusFrame.fillColor
        
        return node
    }()
    
    // MARK:- 聚焦框方法
    // 隐藏聚焦框.
    public func hide() {
        guard action(forKey: "hide") == nil else { return }
        
        runAction(.fadeOut(duration: 0.5), forKey: "hide")
    }
    
    // 取消隐藏聚焦框
    public func unhide() {
        guard action(forKey: "unhide") == nil else { return }
        runAction(.fadeIn(duration: 0.5), forKey: "unhide")
    }
    
    // 开始时让聚焦框平行于摄像机平面显示
    public func displayOnCamera() {
        eulerAngles.x = -.pi / 2
        simdPosition = float3(0, 0, -0.8)
        unhide()
        performOpenAnimation()
    }
    
    /// 当检测到表面时调用
    private func displayAsOpen(at position: float3, camera: ARCamera?) {
        performOpenAnimation()
        recentFocusSquarePositions.append(position)
        updateTransform(for: position, camera: camera)
    }
    
    /// 当检测到平面时调用.
    private func displayAsClosed(at position: float3, planeAnchor: ARPlaneAnchor, camera: ARCamera?) {
        performCloseAnimation(flash: !anchorsOfVisitedPlanes.contains(planeAnchor))
        anchorsOfVisitedPlanes.insert(planeAnchor)
        recentFocusSquarePositions.append(position)
        updateTransform(for: position, camera: camera)
    }
    
    // 更新聚焦框的变换矩阵,总是对齐摄像机.
    private func updateTransform(for position: float3, camera: ARCamera?) {
        simdTransform = matrix_identity_float4x4
        
        // 使用几个最近的位置求平均值.
        recentFocusSquarePositions = Array(recentFocusSquarePositions.suffix(10))
        
        // 移动到最近位置的平均值片,以避免抖动.
        let average = recentFocusSquarePositions.reduce(float3(0), { $0 + $1 }) / Float(recentFocusSquarePositions.count)
        self.simdPosition = average
        self.simdScale = float3(scaleBasedOnDistance(camera: camera))
        
        // 纠正摄像机的y轴旋转
        guard let camera = camera else { return }
        let tilt = abs(camera.eulerAngles.x)
        let threshold1: Float = .pi / 2 * 0.65
        let threshold2: Float = .pi / 2 * 0.75
        let yaw = atan2f(camera.transform.columns.0.x, camera.transform.columns.1.x)
        var angle: Float = 0
        
        switch tilt {
        case 0..<threshold1:
            angle = camera.eulerAngles.y
            
        case threshold1..<threshold2:
            let relativeInRange = abs((tilt - threshold1) / (threshold2 - threshold1))
            let normalizedY = normalize(camera.eulerAngles.y, forMinimalRotationTo: yaw)
            angle = normalizedY * (1 - relativeInRange) + yaw * relativeInRange
            
        default:
            angle = yaw
        }
        eulerAngles.y = angle
    }
    
    // 将角度值规范化到90度这内,这样旋转到其他角度总是最小值.
    private func normalize(_ angle: Float, forMinimalRotationTo ref: Float) -> Float {
        var normalized = angle
        while abs(normalized - ref) > .pi / 4 {
            if angle > ref {
                normalized -= .pi / 2
            } else {
                normalized += .pi / 2
            }
        }
        return normalized
    }
    
    // 调整后的结果是:距离0.7米左右(大约是当注视一张桌子时的距离)时缩放倍数1.0x,距离1.5米左右(大约是当注视地板时的距离)时缩放倍数1.2x
    private func scaleBasedOnDistance(camera: ARCamera?) -> Float {
        guard let camera = camera else { return 1.0 }
        
        let distanceFromCamera = simd_length(simdWorldPosition - camera.transform.translation)
        if distanceFromCamera < 0.7 {
            return distanceFromCamera / 0.7
        } else {
            return 0.25 * distanceFromCamera + 0.825
        }
    }
    
    // MARK: - 动画
    private func performOpenAnimation() {
        guard !isOpen, !isAnimating else { return }
        isOpen = true
        isAnimating = true
        
        // Open animation 打开动画
        SCNTransaction.begin()
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        SCNTransaction.animationDuration = FocusFrame.animationDuration / 4
        positioningNode.opacity = 1.0
        for segment in segments {
            segment.open()
        }
        SCNTransaction.completionBlock = {
            self.positioningNode.runAction(self.pulseAction(), forKey: "pulse")
            // This is a safe operation because `SCNTransaction`'s completion block is called back on the main thread.
            // 这是个线程安全的操作,因为`SCNTransaction`的completion block是在主线程调用的.
            self.isAnimating = false
        }
        SCNTransaction.commit()
        
        // 添加一个缩放/弹簧效果动画
        SCNTransaction.begin()
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        SCNTransaction.animationDuration = FocusFrame.animationDuration / 4
        positioningNode.simdScale = float3(FocusFrame.size)
        SCNTransaction.commit()
    }
    
    private func performCloseAnimation(flash: Bool = false) {
        guard isOpen, !isAnimating else { return }
        isOpen = false
        isAnimating = true
        
        positioningNode.removeAction(forKey: "pulse")
        positioningNode.opacity = 1.0
        
        // 关闭动画
        SCNTransaction.begin()
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        SCNTransaction.animationDuration = FocusFrame.animationDuration / 2
        positioningNode.opacity = 0.99
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            SCNTransaction.animationDuration = FocusFrame.animationDuration / 4
            for segment in self.segments {
                segment.close()
            }
            SCNTransaction.completionBlock = { self.isAnimating = false }
            SCNTransaction.commit()
        }
        SCNTransaction.commit()
        
        // 缩放/弹簧效果动画
        positioningNode.addAnimation(scaleAnimation(for: "transform.scale.x"), forKey: "transform.scale.x")
        positioningNode.addAnimation(scaleAnimation(for: "transform.scale.y"), forKey: "transform.scale.y")
        positioningNode.addAnimation(scaleAnimation(for: "transform.scale.z"), forKey: "transform.scale.z")
        
        if flash {
            let waitAction = SCNAction.wait(duration: FocusFrame.animationDuration * 0.75)
            let fadeInAction = SCNAction.fadeOpacity(to: 0.25, duration: FocusFrame.animationDuration * 0.125)
            let fadeOutAction = SCNAction.fadeOpacity(to: 0.0, duration: FocusFrame.animationDuration * 0.125)
            fillPlane.runAction(SCNAction.sequence([waitAction, fadeInAction, fadeOutAction]))
            
            let flashSquareAction = flashAnimation(duration: FocusFrame.animationDuration * 0.25)
            for segment in segments {
                segment.runAction(.sequence([waitAction, flashSquareAction]))
            }
        }
    }
    
    // scale动画
    private func scaleAnimation(for keyPath: String) -> CAKeyframeAnimation {
        let scaleAnimation = CAKeyframeAnimation(keyPath: keyPath)
        
        let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        let easeInOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let size = FocusFrame.size
        let ts = FocusFrame.size * FocusFrame.scaleForClosedSquare
        let values = [size, size * 1.15, size * 1.15, ts * 0.97, ts]
        let keyTimes: [NSNumber] = [0.00, 0.25, 0.50, 0.75, 1.00]
        let timingFunctions = [easeOut, linear, easeOut, easeInOut]
        
        scaleAnimation.values = values
        scaleAnimation.keyTimes = keyTimes
        scaleAnimation.timingFunctions = timingFunctions
        scaleAnimation.duration = FocusFrame.animationDuration
        
        return scaleAnimation
    }
    
    // flash 动画
    private func flashAnimation(duration: TimeInterval) -> SCNAction {
        let action = SCNAction.customAction(duration: duration) { (node, elapsedTime) -> Void in
            // 动画颜色,从HSB 48/100/100 到 48/30/100,来回变化.
            let elapsedTimePercentage = elapsedTime / CGFloat(duration)
            let saturation = 2.8 * (elapsedTimePercentage - 0.5) * (elapsedTimePercentage - 0.5) + 0.3
            if let material = node.geometry?.firstMaterial {
                material.diffuse.contents = UIColor(hue: 0.1333, saturation: saturation, brightness: 1.0, alpha: 1.0)
            }
        }
        return action
    }
    
    // MARK: - 动作
    
    private func pulseAction() -> SCNAction {
        let pulseOutAction = SCNAction.fadeOpacity(to: 0.4, duration: 0.5)
        let pulseInAction = SCNAction.fadeOpacity(to: 1.0, duration: 0.5)
        pulseOutAction.timingMode = .easeInEaseOut
        pulseInAction.timingMode = .easeInEaseOut
        
        return SCNAction.repeatForever(SCNAction.sequence([pulseOutAction, pulseInAction]))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
