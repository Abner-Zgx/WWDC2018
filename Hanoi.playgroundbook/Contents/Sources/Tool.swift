//
//  Tool.swift
//  Hanoi
//
//  Created by xiang on 2018/3/24.
//  Copyright © 2018年 xiang. All rights reserved.
//

import Foundation
import ARKit

public var number = 6 // 控制甜甜圈数量
public extension float4x4 {
    //将一个矩阵(右手主序)视为平移矩阵,获取其平移分量.
    var translation: float3 {
        let translation = columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

public extension SCNVector3 {
    static func * (first: SCNVector3, second: CGFloat) -> SCNVector3 {
        return SCNVector3(CGFloat(first.x) * second, CGFloat(first.y) * second, CGFloat(first.z) * second)
    }
}

