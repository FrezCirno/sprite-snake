//
//  EyePair.swift
//  sprite-snake
//
//  Created by tzx on 2021/1/2.
//  Copyright © 2021 frezcirno. All rights reserved.
//

import Foundation
import SpriteKit

class EyePair {
    var eyes = [Eye]()
    let scene: SKScene
    let leftEye: Eye
    let rightEye: Eye
    
    init(scene: SKScene, head: SKSpriteNode, scale: CGFloat) {
        self.scene = scene
        self.leftEye = Eye(scene: scene, head: head, xoff: -0.5, yoff: 0.3)
        self.rightEye = Eye(scene: scene, head: head, xoff: 0.5, yoff: 0.3)
        self.eyes.append(leftEye)
        self.eyes.append(rightEye)
        self.setScale(scale)
    }
    
    func update() {
        self.eyes.forEach { $0.update() }
    }
    
    func setScale(_ scale: CGFloat) {
        self.eyes.forEach { $0.setScale(scale) }
    }
    
}
