//
//  HanoiMoveSolver.swift
//  Hanoi
//
//  Created by xiang on 2018/3/23.
//  Copyright © 2018年 xiang. All rights reserved.
//

import UIKit

// 结构体(甜甜圈索引、目标棒的甜甜圈数量、目标棒索引)
public struct DoughnutMove {
    public var doughtnutIndex: Int
    public var destinationDoughnutCount: Int
    public var destinationBarIndex: Int
    
    public init(doughtnutIndex: Int,destinationDoughnutCount: Int,destinationBarIndex: Int) {
        self.doughtnutIndex = doughtnutIndex
        self.destinationDoughnutCount = destinationDoughnutCount
        self.destinationBarIndex = destinationBarIndex
    }
}


public class HanoiSolver: NSObject {
    
    var numberOfDoughnuts:Int
    var leftBar: [Int]
    var middleBar: [Int]
    var rightBar: [Int]
    
    public var bars: [[Int]]
    public var moves: [DoughnutMove]
    
    // 初始化
    public init(numberOfDoughnuts: Int) {
        self.numberOfDoughnuts = numberOfDoughnuts
        
        self.leftBar = []
        for i in 0..<numberOfDoughnuts {
            self.leftBar.append(i)
        }
        
        self.middleBar = []
        self.rightBar = []
        self.bars = [leftBar, middleBar, rightBar]
        self.moves = []
    }
    
    // 递归部分
    public func hanoi(numberOfDoughnuts: Int, from: Int, dependOn: Int, to: Int) {
        if numberOfDoughnuts == 1 {
            move(from: from, to: to)
        } else {
            hanoi(numberOfDoughnuts: numberOfDoughnuts - 1, from: from, dependOn: to, to: dependOn)
            move(from: from, to: to)
            hanoi(numberOfDoughnuts: numberOfDoughnuts - 1, from: dependOn, dependOn: from, to: to)
        }
    }
    
    // 移动的逻辑部分
    public func move(from: Int, to: Int) {
        let doughnut = popDoughnut(bar: from) // 取出from圆盘
        let doughnutIndex = doughnut // 记录初始圆盘
        let destinationDoughnutCount = bars[to].count // 目标柱子的圆盘数量
        
        pushDoughnut(doughnut: doughnut, bar: to) // 目标柱子加入圆盘
        
        let move = DoughnutMove(doughtnutIndex: doughnutIndex, destinationDoughnutCount: destinationDoughnutCount, destinationBarIndex: to) // 初始化HanoiMove
        moves.append(move)
    }
    
    // 弹出
    public func popDoughnut(bar: Int) -> Int {
        return bars[bar].removeLast()
    }
    
    // 压入
    public func pushDoughnut(doughnut: Int, bar: Int) {
        bars[bar].append(doughnut)
    }
    
    // 事先计算好所有逻辑步骤
    public func computeMoves() {
        self.moves = [] // 清空步骤
        hanoi(numberOfDoughnuts: numberOfDoughnuts, from: 0, dependOn: 1, to: 2)
    }
}
