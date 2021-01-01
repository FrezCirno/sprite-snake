//
//  GameScene.swift
//  sprite-snake
//
//  Created by sse-309-03 on 2020/12/29.
//  Copyright © 2020 frezcirno. All rights reserved.
//

import SpriteKit
import GameplayKit

class BattleScene: SKScene {
    
    /**
     * 开始时，玩家的蛇自行移动，相机跟随蛇头
     *  如果玩家的蛇死亡，摄像头停止移动，一段时间后，生成新的玩家
     * 玩家点击屏幕，游戏开始，玩家输入id，蛇由玩家自行控制
     * 玩家的蛇死亡，游戏结束，屏幕变灰，显示玩家分数，同时镜头跟随杀死玩家的蛇
     */
    enum GameStatus {
        case idle    //初始化
        case preview  //演示界面
        case running    //游戏运行中
        case over    //游戏结束
    }
    
    var gameStatus: GameStatus = .idle  //表示当前游戏状态的变量，初始值为初始化状态
    

    var worldsize = CGSize(width: 0, height: 0)
    
    var foodcount = 0
    var foodNode = SKNode()
    var foods: [Food] = []
    
    var botcount = 0
    var snakes: [Snake] = []
    
    override func didMove(to view: SKView) {
        
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.liidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
        
        self.create()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //update game components
        for snake in self.snakes {
            snake.update()
        }
        if (self.snakes.count < self.botcount) {
            _ = self.createSnake(type: "bot", name: String.randName())
        }
        if (self.foods.count < self.foodcount) {
            _ = self.createFood(x: Double.random(in: 0.0..<Double(self.worldsize.width)),
                                y: Double.random(in: 0.0..<Double(self.worldsize.height)),
                                amount: 1)
        }
    }

    func create() {
        if (true) {
            self.worldsize = CGSize(width: 700, height: 1000)
            self.foodcount = 0
            self.botcount = 0
        } else {
            self.worldsize = CGSize(width: 5000, height: 5000)
            self.foodcount = 500
            self.botcount = 20
        }
        
        // 填充背景
        let map = SKNode()
        
        let tileSet = SKTileSet(named: "My Grid Tile Set")!
        let tileTiles = tileSet.tileGroups.first { $0.name == "Tile" }
        let sandTiles = tileSet.tileGroups.first { $0.name == "Sand" }
        
        let tileSize = CGSize(width: 40, height: 40)
        let columns = Int(self.worldsize.width / tileSize.width)
        let rows = Int(self.worldsize.height / tileSize.height)
        
        let bottonLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottonLayer.fill(with: tileTiles)
        map.addChild(bottonLayer)
        map.position = CGPoint(x: 0, y: 0)
        
        addChild(map)
        
        
//        self.physics.world.setBounds(-self.worldsize[0] / 2, -self.worldsize[1] / 2, self.worldsize[0], self.worldsize[1])

//        self.physics.world.on("worldbounds", function (body) {
//            body.gameObject._snake.destroy()
//        })

        // 随机创建食物
        addChild(self.foodNode)
        
        for _ in 0..<self.foodcount {
            _ = self.createFood(x: Double.random(in: 0.0..<Double(self.worldsize.width)),
                                y: Double.random(in: 0.0..<Double(self.worldsize.height)))
        }
        
        //create bots
        for _ in 0..<self.botcount {
            _ = self.createSnake(type: "bot", name: String.randName())
        }

        // 跟随某个bot
//        self.cameras.main.startFollow(self.snakes[0].head)
//            .setBounds(-self.worldsize[0] / 2, -self.worldsize[1] / 2, self.worldsize[0], self.worldsize[1])

        // 重新进入此scene时(说明gameover), 创建玩家
//        self.events.on("resume", () => {
//            var player = self.createSnake(PlayerSnake, prompt("Please enter your name", "player"))
//            self.cameras.main
//                .startFollow(player.head)
//                .setLerp(1, 1)
//        }, self)
//
//        self.events.on("resize", () => {
//            self.game.config.width = window.innerWidth
//            self.game.config.height = window.innerHeight
//        })
    }
    /**
     *  snake
     */
    func createSnake(type: String = "bot", name: String) -> Snake {
        var x = 0.0, y = 0.0
        var snake: Snake
        while (true) {
            x = Double.random(in: 0.0..<Double(self.worldsize.width))
            y = Double.random(in: 0.0..<Double(self.worldsize.height))
//            var closest = self.physics.closest({ x, y }, self.snakes.reduce((res, snake) => res.concat(snake.sectionGroup.getChildren()), []))
//            if (!closest) {break}
//            var dis = distance_squared((closest.x, closest.y), (x,y))
//            if (dis > 100) {break}
            break
        }
        if type == "bot" {
            snake = BotSnake(x:x, y:y, name:name)
        }
        else {
            snake = PlayerSnake(x:x,y:y,name:name)
        }
//        s.head.setCollideWorldBounds(true)
//        s.head.body.onWorldBounds = true
        addChild(snake.sections)
        snakes.append(snake)
        return snake
    }

    /**
     * Create a piece of food at a point
     * @param  {number} x x-coordinate
     * @param  {number} y y-coordinate
     * @return {Food}   food object created
     */
    func createFood(x: Double, y: Double, amount: Double = Double.random(in: 0.5..<1), key: String = "food") -> Food? {
        if let food = Food(fileNamed: key) {
            food.name = "food"
            
//            food.tint = Int.randomIntNumber(upper: 0xffffff)
            food.alpha = CGFloat(Double.random(in: 0.5..<1))
            food.userData?["amount"] = amount
            food.setScale(CGFloat(0.3 + amount))
            
            //food.body.setCircle(food.width * 0.5)
            self.foods.append(food)
            return food
        }
        return nil
    }

    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
}
