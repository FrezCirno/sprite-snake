#  设计思路

## 场景 Scene

1. 开始菜单场景 MenuScene

2. 游戏中场景 GameScene

3. 游戏结束场景

## 需要的碰撞检测

1. 蛇头**检测器**与其他所有**蛇身**（包括蛇头）
    1. 其他所有**蛇身**（包括蛇头）存储在每条蛇的内部数据（enemies）中
        1. 每次创建一条蛇的时候要更新所有蛇的enemies
        2. 和新创建的蛇的enemies
    2. Snake内部要存储enemies

2. **蛇头**与**地图边界**

    1. Snake内部要存储head
    2. head需要

3. **蛇头**与所有**食物**节点

    1. Snake内部要存储head

## 类设计

* Food
    * amount
    * color
    * ...

* Snake
    * root: SKNode 内含sections，detector，label等，用于渲染
    * sections: SKNode 包含蛇身所有节点，包括head
    * head: SKSpriteNode 蛇头节点
    * label: SKLabelNode 名字的标签，始终位于蛇头上方
    * enemies 其他所有蛇的节，就是碰到会死的节点
    * 
    * update() 计算loss
    * 

* GameScene: SKScene
    * (internal) scene 界面类
    * snakes: [Snake]
    * foodNode: SKNode 所有食物的容器
    * createSnake() 创建一条蛇
        * 将蛇对象加入snakes中，将蛇的所有节点（body节点）加到scene中
        * 更新所有蛇的enemies，和新创建的蛇的enemies
        * 
    * createFood() 创建一个食物
    * (override) update() 更新界面，检查是否需要创建新的食物/蛇
        * 

## 物理引擎使用

* 线速度：velocity

* 角度：zRotation

* 角速度：angularVelocity

## 逻辑

 * 开始时，玩家的蛇自行移动，相机跟随蛇头
 *  如果玩家的蛇死亡，摄像头停止移动，一段时间后，生成新的玩家
 * 玩家点击屏幕，游戏开始，玩家输入id，蛇由玩家自行控制
 * 玩家的蛇死亡，游戏结束，屏幕变灰，显示玩家分数，同时镜头跟随杀死玩家的蛇
 
## 层次结构

- SKScene
    - SKNode 背景组
        - SKTileMapNode
        - SKTileMapNode
        - SKTileMapNode
        - ......
    - SKCameraNode 摄像头节点
    - SKNode 食物组
        - SKSpriteNode 一个食物
        - SKSpriteNode 一个食物
        - SKSpriteNode 一个食物
        - .......
    - SKNode 蛇0（玩家）
        - SKLabelNode 名字标签
        - SKNode 蛇身
            - SKSpriteNode 蛇头
                - SKSpriteNode 眼睛1
                - SKSpriteNode 眼睛2
                - SKSpriteNode 碰撞探测器
            - SKSpriteNode 蛇身1
            - SKSpriteNode 蛇身2
            - ......
    - SKNode 蛇1
        - SKLabelNode 名字标签
        - SKNode 蛇身
            - SKSpriteNode 蛇头
                - SKSpriteNode 眼睛1
                - SKSpriteNode 眼睛2
                - SKSpriteNode 碰撞探测器
            - SKSpriteNode 蛇身1
            - SKSpriteNode 蛇身2
            - ......
    - SKNode 蛇2
    - SKNode 蛇3

## 行进方向确定

当前角度/速度方向 zRotation

点击位置（基于原点） touch_pos



## 蛇身设计

蛇头坐标

行进速度

节之间的距离

初识长度

蛇身节数

## AI设计




