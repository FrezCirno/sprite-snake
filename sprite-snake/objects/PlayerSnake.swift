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

    var touchPos: CGPoint? = nil
    
    override init(scene: SKScene, pos: CGPoint, name: String) {
        super.init(scene: scene, pos: pos, name: name)
    }

    func touchDown(atPoint pos : CGPoint) {
        touchPos = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        touchPos = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        touchPos = nil
    }
    
    /**
     * Add functionality to the original snake update method so that the player
     * can control where self snake goes
     */
    override func update() {
        let thisPos = self.head.position
        let rot = self.head.zRotation
        
        if let touchPos = touchPos {
            let targetDirect = CGVector(dx: touchPos.x - thisPos.x, dy: touchPos.y - thisPos.y)
            var diff = atan2(targetDirect.dy, targetDirect.dx) - rot
            if diff > CGFloat.pi {
                diff -= 2 * CGFloat.pi
            }
            else if diff < -CGFloat.pi {
                diff += 2 * CGFloat.pi
            }
            self.head.physicsBody?.angularVelocity = diff * Snake.rotateSpeed // 不断调整角速度以达到平滑转弯的效果
        } else {
            self.head.physicsBody?.angularVelocity = 0
        }

        // self.status.setText('Your length: ' + self.sectionGroup.getLength())

        // var list = self.scene.snakes
        //     .map(snake => ({ text: snake.label.text, size: snake.sectionGroup.getLength(), snake }))
        //     .sort((a, b) => b.size - a.size)
        //     .map((snake, index) => Phaser.Utils.String.Pad(index + 1, 3, ' ', 1) + '  ' + Phaser.Utils.String.Pad(snake.text, 10, ' ', 2) + snake.size)

        // list.unshift('  #  Rank list')

        // self.rank.setText(list)

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
