//
//  GameScene.swift
//  sprite-snake
//
//  Created by sse-309-03 on 2020/12/29.
//  Copyright © 2020 frezcirno. All rights reserved.
//

import SpriteKit
import GameplayKit


enum GameSceneState {
    case Idle    //初始化
    case Preview  //演示界面
    case Running    //游戏运行中
    case Over    //游戏结束
}


class BattleScene: SKScene, SKPhysicsContactDelegate {
    
    /* Scene connections */
    var score: SKLabelNode!
    var scoreBoard: SKLabelNode!
    
    /* UI Connections */
//    var buttonRestart: MSButtonNode!
//    var scoreLabel: SKLabelNode!
    
    /* Timers */
//    var sinceTouch: CFTimeInterval = 0
//    var spawnTimer: CFTimeInterval = 0
    
    /* Game constants */
//    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
//    let scrollSpeed: CGFloat = 160
    
    /* Game management */
    var gameState: GameSceneState = .Running
    
    
    var worldSize = CGSize(width: 0, height: 0)
    
    var foodCount = 0
    var foodNode = SKNode()
//    var foods: [Food] = []
    
    var botCount = 0
    var snakes: [Snake] = []
    
    let cam = SKCameraNode()
    var followedSnake: Snake?
    
    var foodQuadTree: GKQuadtree<SKNode>! = nil
    
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set physics contact delegate */
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zero
        
        // Get label node from scene and store it for use later
        /* "//x" -> Recursive node search for 'x' (child of referenced node) */
        self.score = (self.childNode(withName: "ScoreNode") as! SKLabelNode)
        self.scoreBoard = (self.childNode(withName: "ScoreBoardNode") as! SKLabelNode)

        /* Set up camera */
        self.camera = cam
        
        self.create()
    }
    
    func create() {
        if (true) {
            self.worldSize = CGSize(width: 1000, height: 1000)
            self.foodCount = 10
            self.botCount = 1
        } else {
            self.worldSize = CGSize(width: 5000, height: 5000)
            self.foodCount = 500
            self.botCount = 20
        }
        
        // Label
        self.score.horizontalAlignmentMode = .left
        self.score.verticalAlignmentMode = .top
        self.score.fontName = "Halogen"
        
        self.scoreBoard.horizontalAlignmentMode = .right
        self.scoreBoard.verticalAlignmentMode = .top
        self.scoreBoard.fontName = "Halogen"
        
        // 填充背景
        let map = SKNode()
        
        let tileSet = SKTileSet(named: "My Grid Tile Set")!
        let tileTiles = tileSet.tileGroups.first { $0.name == "Tile" }
        
        let tileSize = CGSize(width: 40, height: 40)
        let columns = Int(self.worldSize.width / tileSize.width)
        let rows = Int(self.worldSize.height / tileSize.height)
        
        let bottonLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottonLayer.fill(with: tileTiles)
        map.addChild(bottonLayer)
        map.position = CGPoint(x: 0, y: 0)
        
        addChild(map)
        
        
//        self.physics.world.setBounds(-self.worldsize[0] / 2, -self.worldsize[1] / 2, self.worldsize[0], self.worldsize[1])

//        self.physics.world.on("worldbounds", function (body) {
//            body.gameObject._snake.destroy()
//        })
        
        // foodQuadTree
        let bounding = GKQuad(quadMin: vector2(
                                Float(-self.worldSize.width/2), Float(-self.worldSize.height/2)),
                              quadMax: vector2(
                                Float(self.worldSize.width/2), Float(self.worldSize.height/2)))
        self.foodQuadTree = GKQuadtree<SKNode>(boundingQuad: bounding, minimumCellSize: 10.0)

        // 随机创建食物
        for _ in 0..<self.foodCount {
            _ = self.createFood(x: Double.random(in: 0.0..<Double(self.worldSize.width)),
                                y: Double.random(in: 0.0..<Double(self.worldSize.height)))
        }
        addChild(self.foodNode)
        
        // 随机创建蛇
        for _ in 0..<self.botCount {
            _ = self.createSnake(type: "bot", name: String.randName())
        }

        // 跟随某个bot
        self.followedSnake = self.snakes[0]
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        if bodyA.categoryBitMask
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // update camera
        if let position = self.followedSnake?.head?.position {
            self.cam.position = position
            
            // update label
            self.score.position = CGPoint(x: position.x-deviceWidth/2+50,
                                          y: position.y+deviceHeight/2-50)
            self.scoreBoard.position = CGPoint(x: position.x+deviceWidth/2-50,
                                               y: position.y+deviceHeight/2-50)
            self.score.text = "Your Length: 0"
            self.scoreBoard.text = "Your Length: 0"
        }
        
        // update every snake
        for snake in self.snakes {
            snake.update()
        }
        
        // try create a snake
        if (self.snakes.count < self.botCount) {
            _ = self.createSnake(type: "bot", name: String.randName())
        }
        
        // try create a food
        if (self.foodNode.children.count < self.foodCount) {
            _ = self.createFood(x: Double.random(in: 0.0..<Double(self.worldSize.width)),
                                y: Double.random(in: 0.0..<Double(self.worldSize.height)),
                                amount: 1)
        }
    }

    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    
    func randomPoint() -> CGPoint {
        let xrange = (-self.worldSize.width/2)...(self.worldSize.width/2)
        let yrange = (-self.worldSize.height/2)...(self.worldSize.height/2)
        return CGPoint(x: CGFloat.random(in: xrange), y: CGFloat.random(in: yrange))
    }
    
    func randomPointForSnake() -> CGPoint? {
        let bounding = GKQuad(quadMin: vector2(
                                Float(-self.worldSize.width/2), Float(-self.worldSize.height/2)),
                              quadMax: vector2(
                                Float(self.worldSize.width/2), Float(self.worldSize.height/2)))
        let quadTree = GKQuadtree<SKNode>(boundingQuad: bounding, minimumCellSize: 10)
        for snake in snakes {
            for sec in snake.root.children {
                quadTree.add(sec, at: vector2(Float(sec.position.x), Float(sec.position.y)))
            }
        }
        
        var try_time = 0
        while try_time < 10 {
            let pos = randomPoint()
            let lb = vector2(Float(pos.x), Float(pos.y))
            let rt = vector2(Float(pos.x), Float(pos.y))
            let region = GKQuad(quadMin: lb, quadMax: rt)
            let elements = quadTree.elements(in: region)
            if let first = elements.first {
                let closest_pos = first.position
                let dist2 = CGPointDistanceSquared(from: pos, to: closest_pos)
                if dist2 > 100 {
                    return pos
                }
            } else {
                return pos
            }
            try_time += 1
        }
        return nil
    }
    
    /**
     *  snake
     */
    func createSnake(type: String = "bot", name: String) -> Snake {
        var snake: Snake
        let pos = randomPointForSnake()!
        if type == "bot" {
            snake = BotSnake(scene: self, pos: pos, name: name)
        }
        else {
            snake = PlayerSnake(scene: self, pos: pos, name: name)
        }
//        s.head.setCollideWorldBounds(true)
//        s.head.body.onWorldBounds = true
        for enemy in snakes {
            enemy.enemies.append(contentsOf: snake.sections.children)
            snake.enemies.append(contentsOf: enemy.sections.children)
        }
        snakes.append(snake)
        addChild(snake.root)
        return snake
    }

    /**
     * Create a piece of food at a point
     * @param  {number} x x-coordinate
     * @param  {number} y y-coordinate
     * @return {Food}   food object created
     */
    func createFood(x: Double, y: Double, amount: Double = Double.random(in: 0.5..<1), key: String = "hex.png") -> Food {
        let food = Food(imageNamed: key)
        food.color = UIColor(red: CGFloat.random(in: 0.5...1),
                             green: CGFloat.random(in: 0.5...1),
                             blue: CGFloat.random(in: 0.5...1),
                             alpha: CGFloat.random(in: 0.4...0.8))
        food.colorBlendFactor = 1
        food.userData?.setValue(amount, forKey: "amount")
        food.setScale(CGFloat(0.3 + amount))
        food.position = self.randomPoint()
        food.physicsBody = SKPhysicsBody(circleOfRadius: food.xScale / 8, center: food.position)
        food.physicsBody?.categoryBitMask = Category.Food.rawValue
        food.physicsBody?.collisionBitMask = 0
        food.physicsBody?.contactTestBitMask = 0
        self.foodNode.addChild(food)
        self.foodQuadTree.add(food, at: vector2(Float(food.position.x), Float(food.position.y)))
        return food
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
    
    func closestSnake(pos: CGPoint, t: CGFloat = 200, l: CGFloat = 200, b: CGFloat = 200, r: CGFloat = 200) -> Snake? {
        let bounding = GKQuad(quadMin: vector2(
                                Float(-self.worldSize.width/2), Float(-self.worldSize.height/2)),
                              quadMax: vector2(
                                Float(self.worldSize.width/2), Float(self.worldSize.height/2)))
        let quadTree = GKQuadtree<SKNode>(boundingQuad: bounding, minimumCellSize: 10)
        for snake in self.snakes {
            for sec in snake.sections.children {
                quadTree.add(sec, at: vector2(Float(sec.position.x), Float(sec.position.y)))
            }
        }
        
        let bounding2 = GKQuad(quadMin: vector2(Float(pos.x-l), Float(pos.y-b)),
                              quadMax: vector2(Float(pos.x+r), Float(pos.y+t)))
        
        return quadTree.elements(in: bounding2).first?.userData?.value(forKey: "snake") as? Snake
    }
    
}
