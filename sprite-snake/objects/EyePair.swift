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
    let scene: GameScene
    let leftEye: Eye
    let rightEye: Eye
    
    init(scene: GameScene, head: SKSpriteNode) {
        self.scene = scene
        self.leftEye = Eye(scene: scene, head: head, xoff: 0.3, yoff: -0.5)
        self.rightEye = Eye(scene: scene, head: head, xoff: 0.3, yoff: 0.5)
        self.eyes.append(leftEye)
        self.eyes.append(rightEye)
    }
    
    func update() {
        self.eyes.forEach { $0.update() }
    }
}
