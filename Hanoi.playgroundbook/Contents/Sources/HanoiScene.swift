//
//  HanoiScene.swift
//  Hanoi
//
//  Created by xiang on 2018/3/23.
//  Copyright © 2018年 xiang. All rights reserved.
//

import UIKit
import SceneKit

public class HanoiScene: SCNScene {
    
    // 巧克力棒属性
    public var barSpace: CGFloat = 0.2
    public var barHeight: CGFloat = 0
    public var bars: [SCNNode] = [] // 巧克力棒节点数组

    // 甜甜圈属性
    public var numberOfDoughnuts: Int = 3
    public var doughnutHeight: Float = 0
    public var doughnutColors = [#colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    public var doughnuts: [SCNNode] = [] //甜甜圈节点数组
    
    // 动画属性
    public var duration: TimeInterval = 0.1
    public var waitTime: TimeInterval = 0
    public var step: Int = 0
    
    // 大小
    public var scale: CGFloat = 1
    
    public var hanoiSolver: HanoiSolver?
    
    public var particleColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    public var particleSize:CGFloat = 0.01
    
    override public init() {
        super.init()
        setupLight()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  设置灯光
    public func setupLight() {
        let light = SCNLight()
        light.type = .directional
        light.color = UIColor(white: 1,alpha: 0.8)
        light.shadowColor = UIColor(white: 1,alpha: 0.8).cgColor
        
        let lightNode = SCNNode()
        lightNode.eulerAngles = SCNVector3Make(-.pi/3, .pi/4,0)
        lightNode.light = light
        rootNode.addChildNode(lightNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor(white: 0.6,alpha: 0.6)
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        rootNode.addChildNode(ambientNode)

    }
    
    // MARK:- 设置甜甜圈
    public func setupDoughnuts(withFocus framePosition: SCNVector3) {
        let frameX = CGFloat(framePosition.x)
        let frameY = CGFloat(framePosition.y)
        let frameZ = CGFloat(framePosition.z)
        
        for i in 1 ... numberOfDoughnuts {
            
            // x长 y高 z宽
            guard let doughnutScene = SCNScene(named: "art.scnassets/Doughnut.scn") else { return }
            guard let doughnutNode = doughnutScene.rootNode.childNode(withName: "doughnut", recursively: false) else { return }
            doughnutHeight = (doughnutNode.boundingBox.max.y - doughnutNode.boundingBox.min.y) * doughnutNode.scale.y * Float(scale)
            barSpace = CGFloat(doughnutHeight * 7)
            let doughnutYPos = CGFloat((Float(i) - 0.5) * doughnutHeight)// 位置
            doughnutNode.scale.x += (Float(numberOfDoughnuts) - Float(i)) * doughnutNode.scale.x * 0.1 // x长
            doughnutNode.scale.z += (Float(numberOfDoughnuts) - Float(i)) * doughnutNode.scale.z * 0.1 // y宽
            doughnutNode.scale = doughnutNode.scale * scale
            doughnutNode.position = SCNVector3(frameX - barSpace, frameY + doughnutYPos, frameZ)
            doughnutNode.categoryBitMask = Int(i) // id
            let cream = doughnutNode.childNode(withName: "Cream", recursively: false) // 奶油
            cream?.geometry?.firstMaterial?.diffuse.contents = doughnutColors[Int(i-1)]
            doughnuts.append(doughnutNode)
            rootNode.addChildNode(doughnutNode)
                
        }
        
    }
    
    //MARK:- 设置巧克力棒
    public func setupBars(withFocus framePosition: SCNVector3) {
        
        let frameX = CGFloat(framePosition.x)
        let frameY = CGFloat(framePosition.y)
        let frameZ = CGFloat(framePosition.z)
        
        var x = -barSpace
        
        for _ in 0..<3 {
            guard let barScene = SCNScene(named: "art.scnassets/ChocolateBar.scn") else { return }
            guard let barNode = barScene.rootNode.childNode(withName: "chocolateBar", recursively: false) else { return }
            
            barNode.position = SCNVector3(frameX + x, frameY, frameZ)
            barHeight = CGFloat((barNode.boundingBox.max.y - barNode.boundingBox.min.y) * barNode.scale.y) * scale // 高度
            barNode.scale = barNode.scale * scale
            let particle = SCNParticleSystem(named: "flower", inDirectory: nil)
            particle?.particleColor = particleColor
            particle?.particleSize = particleSize
            barNode.addParticleSystem(particle!)
            rootNode.addChildNode(barNode)
            bars.append(barNode)
            x += barSpace
        }
    }
    
    // 移动的动画部分（参数是逻辑）
    public func animationFromMove(move: DoughnutMove, withFocus framePosition: SCNVector3) -> SCNAction {
        
        let frameY = Float(framePosition.y)
        
        let doughnut = doughnuts[move.doughtnutIndex] // 要移动的甜甜圈
        let destination = bars[move.destinationBarIndex] // 移动目标巧克力棒
        
        // 上移
        var topPosition = doughnut.position
        topPosition.y = frameY + Float(barHeight) + doughnutHeight * 2.0

        let moveUp = SCNAction.move(to: topPosition, duration: duration)
        
        // 移动
        var sidePosition = destination.position
        sidePosition.y = topPosition.y
        let moveSide = SCNAction.move(to: sidePosition, duration: duration)
        
        // 下移
        var bottomPosition = sidePosition
        bottomPosition.y = frameY + (doughnutHeight / 2.0) + Float(move.destinationDoughnutCount) * Float(doughnutHeight)
        let moveDown = SCNAction.move(to: bottomPosition,duration: duration)
        
        let sequence = SCNAction.sequence([moveUp, moveSide, moveDown])
        return sequence
    }
    
    // 递归动画
    public func recursiveAnimation(index: Int, withFocus framePosition: SCNVector3) {
        
        let move = hanoiSolver!.moves[index] // 第index个要移动的甜甜圈信息
        let node = doughnuts[move.doughtnutIndex] // 要移动的甜甜圈
        let animation = animationFromMove(move: move, withFocus: framePosition) // 要执行的动画
        
        node.runAction(animation, completionHandler: {
            if (index + 1 < self.hanoiSolver!.moves.count) {
                self.recursiveAnimation(index: index + 1, withFocus: framePosition)
            }
        })
    }
    
    // 开始执行动画
    public func startToAnimation(withFocus framePosition: SCNVector3) {
        hanoiSolver!.computeMoves() // 先进行计算
        recursiveAnimation(index: 0, withFocus: framePosition) // 然后开始执行动画
    }
    
}
