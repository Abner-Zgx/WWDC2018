//
//  Tool.swift
//  Hanoi
//
//  Created by xiang on 2018/3/24.
//  Copyright © 2018年 xiang. All rights reserved.
//

import SpriteKit
import GameKit

public class InitialScene: SKScene {
    
    let dessertArray = ["doughnut1","doughnut2","doughnut3","doughnut4","doughnut5","doughnut6","chocolateBar"]
    
    override public func didMove(to view: SKView) {
        
        // background
        let background = SKSpriteNode(imageNamed: "backgroundImage")
        background.name = "background"
        background.setScale(1)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        setUpInitialScene()
        setUpText()
        randomAddDessertForever()
    }
    
    // initial Scene
    func setUpInitialScene() {
        scaleMode = .resizeFill
        // physicsWorld.gravity = CGVector.zero
        physicsWorld.gravity = CGVector.init(dx: 0, dy: -1)
        //view?.isMultipleTouchEnabled = true
        
    }
    
    // AR Hanoi
    func setUpText() {
        
//        let ARHanoi = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
//        ARHanoi.text = "Hanoi"
//        ARHanoi.fontColor = SKColor.blue
//        ARHanoi.fontSize = 80
        
        let ARHanoi = SKSpriteNode(imageNamed: "HANOI")
        ARHanoi.name = "HANOI"
        ARHanoi.setScale(0.3)
        ARHanoi.position = CGPoint(x: frame.midX, y: frame.midY)
        ARHanoi.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ARHanoi.frame.width * 1 , height: ARHanoi.frame.height))
        ARHanoi.physicsBody?.isDynamic = false
        //ARHanoi.fontColor = SKColor.black
        //ARHanoi.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(ARHanoi)
    }
    
    func randomAddDessertForever() {
        
        let wait = SKAction.wait(forDuration:0.1)
        let action = SKAction.run {
            let x = arc4random_uniform(UInt32(self.frame.maxX))
            let y = self.frame.maxY
            
            self.addDessert(at: CGPoint(x: CGFloat(x), y: y))
        }
        
        run(SKAction.repeat(SKAction.sequence([wait, action]), count: 100))
    }
    
    // doughnuts and chocolateBars
    func addDessert(at point: CGPoint) {
        //let randomIndex =  GKRandomSource.sharedRandom().nextInt(upperBound: dessertArray.count)
        let count: Int = dessertArray.count
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        let randomDessert = dessertArray[randomIndex]
        
        let dessert = SKSpriteNode(imageNamed: randomDessert)
        
        dessert.name = "dessert"
        dessert.position = CGPoint(x: point.x, y: point.y)
        dessert.physicsBody?.isDynamic = false
        
        // bar
        if randomDessert == "chocolateBar" {
            
            dessert.setScale(0.1)
            let space: CGFloat = 1.25
            dessert.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dessert.frame.size.width * space , height: dessert.frame.size.height * space))
            
            addChild(dessert)
            
        }else {
            // doughnut
            dessert.setScale(1)
            let maxRadius = max(dessert.frame.size.width/2, dessert.frame.size.height/2)
            let space: CGFloat = 1.25
            dessert.physicsBody = SKPhysicsBody(circleOfRadius: maxRadius * space)
            
            addChild(dessert)
        }
    }
}
