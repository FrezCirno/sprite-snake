#  Snake.io

## 游戏简介

用SpriteKit实现的 Slither.io (中文: 贪吃蛇大作战), 学习工作之余可以用来放松, 单机版无需联网

实现的功能:

- 玩家移动(镜头控制)
    - 平滑的转弯
    - 双击高速移动
    - 吃到食物增长
- 碰撞检测
    - 每条蛇与其他蛇的碰撞判断
    - 每条蛇与地图边界的碰撞判断
    - 每条蛇的蛇头与食物的碰撞判断
- 装饰组件
    - 眼睛👀跟踪手指
    - 阴影 (高速移动时会闪烁)
- AI bot
    - 自动寻找食物
    - 自动避障
    - 参数为随机生成
- 得分与计分榜

与原版的主要区别:

- 原版为多人联机对战, 此处为单机版, 敌人都是AI

## 场景 Scenes

- [] 开始菜单场景 MainMenu

- [x] 游戏中场景 GameScene
<!-- 
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

    1. Snake内部要存储head -->

## 类设计

* `Snake` - 贪吃蛇基类

    * `root: SKNode` - 内含sections, detector, label等, 用于渲染
  
    * `sections: SKNode` - 包含蛇身所有节点, 包括head
 
    * `head: SKSpriteNode` - 蛇头节点
  
    * `label: SKLabelNode` - 名字的标签, 始终位于蛇头上方

    * `eyes: EyePair` - 贪吃蛇的眼睛

    * `shadow: SKNode` - 阴影

    * `update()` - 状态更新

* `BotSnake: Snake` - AI控制的蛇

    * `careness: CGFloat`

    * `distcareness: CGFloat`

    * `anglecareness: CGFloat`

    * `worldBoundCareness: CGFloat`

    * `boundTurnTrend1: CGFloat`

    * `boundTurnTrend2: CGFloat`

    * `trendRotation: CGFloat`


* `GameScene: SKScene`

    <!-- * `(internal) scene` - 界面类 -->
  
    * `worldSize: CGSize` - 地图大小
  
    * `camera: CGSize` - 地图大小

    * `snakes: [Snake]` - 地图上的所有蛇
   
    * `foodNode: SKNode` - 所有食物的容器
   
    * `createSnake()` - 创建一条蛇

        * 将蛇对象加入snakes中, 将蛇的所有节点（body节点）加到scene中

        * 使用空间四叉树`GKQuadtree`来防止新生成的蛇和其他蛇距离过近
 
    * `createFood()` - 创建一个食物

        * 在地图上随机生成一颗食物

        * 同样维护了一棵空间四叉树`GKQuadtree`来记录所有食物的位置, 供AI算法使用

    * `(override) update()` - 更新界面, 依次更新所有蛇, 检查是否需要创建新的食物/蛇

## 物理引擎使用

蛇的平滑转弯实现:

```swift
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
```

* 线速度：velocity

* 角度：zRotation

* 角速度：angularVelocity

<!-- ## 游戏逻辑

 * 开始时, 玩家的蛇自行移动, 相机跟随蛇头
 * 如果玩家的蛇死亡, 摄像头停止移动, 一段时间后, 生成新的玩家
 * 玩家点击屏幕, 游戏开始, 玩家输入id, 蛇由玩家自行控制
 * 玩家的蛇死亡, 游戏结束, 屏幕变灰, 显示玩家分数, 同时镜头跟随杀死玩家的蛇 -->
 
## 层次结构

- `SKScene`
    - `SKNode` - 背景组
        - `SKTileMapNode`
        - `SKTileMapNode`
        - `SKTileMapNode`
        - ......
    - `SKCameraNode` - 摄像头节点
    - `SKNode` - 食物组
        - `SKSpriteNode(phy)` - 一个食物
        - `SKSpriteNode(phy)` - 一个食物
        - `SKSpriteNode(phy)` - 一个食物
        - .......
    - `SKNode` - 玩家
        - `SKLabelNode` - 名字标签
        - `SKNode` - 蛇身
            - `SKSpriteNode(phy)` - 蛇头
                - `SKSpriteNode` - 眼睛1
                - `SKSpriteNode` - 眼睛2
                - `SKSpriteNode(phy)` - 碰撞探测器
            - `SKSpriteNode(phy)` - 蛇身1
            - `SKSpriteNode(phy)` - 蛇身2
            - ......
    - `SKNode` - 蛇1
        - `SKLabelNode` - 名字标签
        - `SKNode` - 蛇身
            - `SKSpriteNode` - 蛇头
                - `SKSpriteNode` - 眼睛1
                - `SKSpriteNode` - 眼睛2
                - `SKSpriteNode` - 碰撞探测器
            - `SKSpriteNode` - 蛇身1
            - `SKSpriteNode` - 蛇身2
            - ......
    - `SKNode` - 蛇2
    - `SKNode` - 蛇3

## 注意

size表示在父坐标系下的尺寸

scale表示对父坐标系的伸缩变化

修改scale的时候会同时修改size

修改size的时候不会修改scale

## AI设计

* 判断一定范围内有没有食物

* 判断最近的敌人的位置

* 判断是否靠近边界

* 随意选择一个感兴趣方向进行探索
