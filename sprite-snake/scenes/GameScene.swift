//
//  GameScene.swift
//  sprite-snake
//
//  Created by sse-309-03 on 2020/12/29.
//  Copyright © 2020 frezcirno. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
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
    

    var worldsize = (0,0)
    var foodcount = 0
    var botcount = 0






    /**
     * 如何表示一条蛇：
     *  head
     */
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var snakeNode : SKSpriteNode?
    
    func restart()  {
        
        //游戏初始化处理方法
        
        gameStatus = .idle
        
    }
    func startGame()  {
        
        //游戏开始处理方法
        
        gameStatus = .running
        
    }
    func gameOver()  {
        
        //游戏结束处理方法
        
        gameStatus = .over
        
    }
    
    func moveScene() {
        
        
    }
    
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameStatus {
        case .idle, .preview:
            startGame()
        case .running:
            break
        case .over:
            restart()
        }
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameStatus != .over {
            
            moveScene()
            
        }
    }



    func create() {
        if (0) {
            self.worldsize = { x: 1000, y: 1000 };
            self.foodcount = 100;
            self.botcount = 10;
        } else {
            self.worldsize = { x: 5000, y: 5000 };
            self.foodcount = 500;
            self.botcount = 20;
        }

        // 填充背景 
        self.add.tileSprite(0, 0, self.worldsize.x, self.worldsize.y, 'background');
        self.physics.world.setBounds(-self.worldsize.x / 2, -self.worldsize.y / 2, self.worldsize.x, self.worldsize.y);

        self.physics.world.on('worldbounds', function (body) {
            body.gameObject._snake.destroy();
        });

        // 初始化物体组
        self.snakes = [];

        // 随机创建食物
        self.foodGroup = self.physics.add.group();
        for (let i = 0; i < self.foodcount; i++) {
            self.createFood(self.rand(self.worldsize.x), self.rand(self.worldsize.y),);
        }

        //create bots
        for (let i = 0; i < self.botcount; i++) {
            self.createSnake(BotSnake, self.randName());
        }

        // 跟随某个bot
        self.cameras.main.startFollow(self.snakes[0].head)
            .setBounds(-self.worldsize.x / 2, -self.worldsize.y / 2, self.worldsize.x, self.worldsize.y)

        // 重新进入此scene时(说明gameover), 创建玩家
        self.events.on('resume', () => {
            var player = self.createSnake(PlayerSnake, prompt("Please enter your name", "player"))
            self.cameras.main
                .startFollow(player.head)
                .setLerp(1, 1)
        }, self)

        self.events.on('resize', () => {
            self.game.config.width = window.innerWidth;
            self.game.config.height = window.innerHeight;
        })
    }
    /**
     * new snake
     */
    createSnake(bot, name) {
        var x, y;
        while (1) {
            x = self.rand(self.worldsize.x - 100)
            y = self.rand(self.worldsize.y - 100)
            var closest = self.physics.closest({ x, y }, self.snakes.reduce((res, snake) => res.concat(snake.sectionGroup.getChildren()), []))
            if (!closest) break;
            var dis = Phaser.Math.Distance.BetweenPoints(closest, { x, y })
            if (dis > 100) break;
        }
        let s = new bot(self, x, y, name)

        s.head.setCollideWorldBounds(true);
        s.head.body.onWorldBounds = true;

        return s;
    }

    randName() {
        const names = ['Apple', 'Banana', 'Cat', 'Trump',
            'Me', 'Sun', 'Snack', 'Snnke',
            'Star', 'Gabrielle', 'Wright',
            'Owen', 'Ferguson', 'Maria', 'Knox',
            'Sally', 'Randall', 'Kevin', 'Walker',
            'Brandon', 'Morgan', 'Kimberly', 'Clark',
            'Faith', 'Lee', 'Adrian', 'May',
            'Adrian', 'Morgan', 'Connor', 'McGrath',
            'Dylan', 'Bell', 'Jasmine', 'Cameron',
            'Emma', 'Rees', 'Caroline', 'Walsh',
            'Joshua', 'Stewart', 'Samantha', 'Forsyth',
            'Brandon', 'Simpson', 'Alan', 'Burgess',
            'Piers', 'Graham']
        return names[Phaser.Math.RND.integerInRange(0, names.length - 1)];
    }
    /**
     * Main update loop
     */
    update() {
        //update game components
        for (let index = 0; index < self.snakes.length; index++) {
            const snake = self.snakes[index];
            snake.update();
        }
        if (self.snakes.length < self.botcount) {
            self.createSnake(BotSnake, self.randName());
        }
        if (self.foodGroup.getLength() < self.foodcount) {
            self.createFood(self.rand(self.worldsize.x), self.rand(self.worldsize.y));
        }
    }

    /**
     * Create a piece of food at a point
     * @param  {number} x x-coordinate
     * @param  {number} y y-coordinate
     * @return {Food}   food object created
     */
    createFood(x, y, amount, key = 'food') {
        const food = self.physics.add.sprite(x, y, key);
        food.name = 'food';
        food.tint = Phaser.Math.RND.integerInRange(0, 0xffffff);
        food.alpha = Phaser.Math.RND.realInRange(0.5, 1)
        food.amount = amount || (Math.random() / 2 + 0.5);
        food.setScale(0.3 + food.amount);
        food.body.setCircle(food.width * 0.5);
        self.foodGroup.add(food);
        return food;
    }

}
