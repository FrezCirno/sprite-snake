//
//  angleBetween.swift
//  sprite-snake
//
//  Created by tzx on 2021/1/2.
//  Copyright © 2021 frezcirno. All rights reserved.
//

import Foundation
import SpriteKit

public extension CGVector {
    
    static func angleBetween(v1:CGVector, v2:CGVector) -> CGFloat{
        return atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
    }
    
    static func angleBetween(p1:CGPoint, p2:CGPoint) -> CGFloat{
        return atan2(p2.y, p2.x) - atan2(p1.y, p1.x)
    }
    
    static func distanceBetween(p1:CGPoint, p2:CGPoint) -> CGFloat{
        return sqrt(pow(p1.x-p2.x,2)+pow(p1.y-p2.y,2))
    }
    
    static func distanceSquareBetween(p1:CGPoint, p2:CGPoint) -> CGFloat{
        return pow(p1.x-p2.x,2)+pow(p1.y-p2.y,2)
    }
    
    func scale(by: CGFloat) -> CGVector {
        return CGVector(dx: dx * by, dy: dy * by)
    }
    
    func nomalize() -> CGVector {
        let len = self.length()
        return CGVector(dx: dx / len, dy: dy / len)
    }
    
    func asPoint() -> CGPoint {
        return CGPoint(x: dx, y: dy)
    }
    
    func proj(to: CGVector) -> CGFloat {
        let res = project(SIMD2(x: Double(dx), y: Double(dy)), SIMD2(x: Double(to.dx), y: Double(to.dy)))
        return CGFloat(res.x) / to.dx
    }
}
