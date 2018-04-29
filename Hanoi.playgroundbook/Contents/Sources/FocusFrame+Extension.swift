//
//  FocusFrame+Extension.swift
//  Hanoi
//
//  Created by xiang on 2018/3/24.
//  Copyright © 2018年 xiang. All rights reserved.
//

import Foundation
import SceneKit

public extension FocusFrame {

    // 角
    public enum Corner {
        case topLeft // s1, s3
        case topRight // s2, s4
        case bottomRight // s6, s8
        case bottomLeft // s5, s7
    }
    
    // 队列
    public enum Alignment {
        case horizontal // s1, s2, s7, s8
        case vertical // s3, s4, s5, s6
    }
    
    // 方向
    public enum Direction {
        case up, down, left, right
        
        var reversed: Direction {
            switch self {
            case .up:   return .down
            case .down: return .up
            case .left:  return .right
            case .right: return .left
            }
        }
    }
    

    
    public class Segment: SCNNode {
        
        // 聚焦框线段的线宽,单位是米.
        static let thickness: CGFloat = 0.018
        
        // 聚焦框线段的线长,单位是米
        static let length: CGFloat = 0.5  // segment length
        
        // 打开状态时聚焦框线段的边的长度
        static let openLength: CGFloat = 0.2
        
        let corner: Corner
        let alignment: Alignment
        let plane: SCNPlane
        
        init(name: String, corner: Corner, alignment: Alignment) {
            
            self.corner = corner
            self.alignment = alignment
            
            // 根据横竖选择长款
            switch alignment {
            case .vertical:
                plane = SCNPlane(width: Segment.thickness, height: Segment.length)
            case .horizontal:
                plane = SCNPlane(width: Segment.length, height: Segment.thickness)
            }
            super.init()
            self.name = name
            
            let material = plane.firstMaterial!
            material.diffuse.contents = FocusFrame.primaryColor
            material.isDoubleSided = true
            material.ambient.contents = UIColor.black
            material.lightingModel = .constant
            material.emission.contents = FocusFrame.primaryColor
            geometry = plane
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("\(#function) has not been implemented")
        }
        
        // 开闭动画的移动方向
        var openDirection: Direction {
            switch (corner, alignment) {
            case (.topLeft,     .horizontal):   return .left
            case (.topLeft,     .vertical):     return .up
            case (.topRight,    .horizontal):   return .right
            case (.topRight,    .vertical):     return .up
            case (.bottomLeft,  .horizontal):   return .left
            case (.bottomLeft,  .vertical):     return .down
            case (.bottomRight, .horizontal):   return .right
            case (.bottomRight, .vertical):     return .down
            }
        }
        
        // 开始动画
        func open() {
            if alignment == .horizontal {
                plane.width = Segment.openLength
            } else {
                plane.height = Segment.openLength
            }
            
            let offset = Segment.length / 2 - Segment.openLength / 2
            updatePosition(withOffset: Float(offset), for: openDirection)
        }
        
        // 关闭动画
        func close() {
            let oldLength: CGFloat
            if alignment == .horizontal {
                oldLength = plane.width
                plane.width = Segment.length
            } else {
                oldLength = plane.height
                plane.height = Segment.length
            }
            
            let offset = Segment.length / 2 - oldLength / 2
            updatePosition(withOffset: Float(offset), for: openDirection.reversed)
        }
        
        // 更新位置
        private func updatePosition(withOffset offset: Float, for direction: Direction) {
            switch direction {
            case .left:     position.x -= offset
            case .right:    position.x += offset
            case .up:       position.y -= offset
            case .down:     position.y += offset
            }
        }
        
    }
}

extension FocusFrame.State: Equatable {
    static public func == (lhs: FocusFrame.State, rhs: FocusFrame.State) -> Bool {
        switch (lhs, rhs) {
        case (.initializing, .initializing):
            return true
            
        case (.featuresDetected(let lhsPosition, let lhsCamera),
              .featuresDetected(let rhsPosition, let rhsCamera)):
            return lhsPosition == rhsPosition && lhsCamera == rhsCamera
            
        case (.planeDetected(let lhsPosition, let lhsPlaneAnchor, let lhsCamera),
              .planeDetected(let rhsPosition, let rhsPlaneAnchor, let rhsCamera)):
            return lhsPosition == rhsPosition
                && lhsPlaneAnchor == rhsPlaneAnchor
                && lhsCamera == rhsCamera
            
        default:
            return false
        }
    }
}
