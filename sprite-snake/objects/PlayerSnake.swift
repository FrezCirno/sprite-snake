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

    override init(scene: SKScene, pos: CGPoint, name:String) {
        super.init(scene: scene, pos: pos, name: name)
    }

    /**
     * Add functionality to the original snake update method so that the player
     * can control where this snake goes
     */
    override func update() {
        // const headX = this.head.x;
        // const headY = this.head.y;
        // const mousePosX = this.scene.input.activePointer.worldX || 0;
        // const mousePosY = this.scene.input.activePointer.worldY || 0;
        // const angle = Phaser.Math.Angle.Between(headX, headY, mousePosX, mousePosY);
        // let dif = angle - this.head.rotation;
        // if (dif > Math.PI) dif -= 2 * Math.PI;
        // else if (dif < -Math.PI) dif += 2 * Math.PI;

        // this.head.setAngularVelocity(dif * this.rotationSpeed); // 不断调整角速度以达到平滑转弯的效果

        // this.status.setText('Your length: ' + this.sectionGroup.getLength())

        // var list = this.scene.snakes
        //     .map(snake => ({ text: snake.label.text, size: snake.sectionGroup.getLength(), snake }))
        //     .sort((a, b) => b.size - a.size)
        //     .map((snake, index) => Phaser.Utils.String.Pad(index + 1, 3, ' ', 1) + '  ' + Phaser.Utils.String.Pad(snake.text, 10, ' ', 2) + snake.size)

        // list.unshift('  #  Rank list')

        // this.rank.setText(list)

        //call the original snake update method
        super.update();
    }

    deinit {
        // var start = this.scene.scene.get('start')
        // start.best = Math.max(start.best || 0, this.sectionGroup.getLength())
        // this.scene.sound.play('death')
        // this.status.destroy();
        // this.rank.destroy();
        // var closest = this.scene.physics.closest(this.head, this.others.map(other => other.getChildren()[0]._snake.head))
        // if (closest) this.scene.cameras.main.startFollow(closest);
        // this.scene.input.off('pointerdown', this.pointerdown, this);
        // this.scene.input.off('pointerup', this.pointerup, this);
//        super.deinit()

        // this.scene.scene.sendToBack('battle').run('start');
    }


}
