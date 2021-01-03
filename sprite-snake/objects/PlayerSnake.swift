//
//  Food.swift
//  sprite-snake
//
//  Created by tzx on 2020/12/31.
//  Copyright © 2020 frezcirno. All rights reserved.
//



import Foundation
import SpriteKit
import GameplayKit


class PlayerSnake: Snake {

    override init(scene: BattleScene, pos: CGPoint, name: String) {
        super.init(scene: scene, pos: pos, name: name)
    }

    /**
     * Add functionality to the original snake update method so that the player
     * can control where self snake goes
     */
    override func update() {
        let thisPos = self.head.position
        let rot = self.head.zRotation
        
        if let touchPos = self.scene.touchPos {
            let targetDirect = CGVector(dx: touchPos.x - thisPos.x, dy: touchPos.y - thisPos.y)
            var diff = atan2(targetDirect.dy, targetDirect.dx) - rot
            if diff > CGFloat.pi {
                diff -= 2 * CGFloat.pi
            }
            else if diff < -CGFloat.pi {
                diff += 2 * CGFloat.pi
            }
            self.head.physicsBody?.angularVelocity = diff * Snake.rotateSpeed // 不断调整角速度以达到平滑转弯的效果
            if self.scene.tapCount > 1 {
                self.speed = Snake.fastSpeed
            } else {
                self.speed = Snake.slowSpeed
            }
        } else {
            self.head.physicsBody?.angularVelocity = 0
            self.speed = Snake.slowSpeed
        }
        
        super.update()
    }

    deinit {
        // var start = self.scene.scene.get('start')
        // start.best = Math.max(start.best || 0, self.sectionGroup.getLength())
        // self.scene.sound.play('death')
        // self.status.destroy();
        // self.rank.destroy();
        // var closest = self.scene.physics.closest(self.head, self.others.map(other => other.getChildren()[0]._snake.head))
        // if (closest) self.scene.cameras.main.startFollow(closest);
        // self.scene.input.off('pointerdown', self.pointerdown, self);
        // self.scene.input.off('pointerup', self.pointerup, self);
//        super.deinit()

        // self.scene.scene.sendToBack('battle').run('start');
    }
}
