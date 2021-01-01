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

3. **蛇头**与所有**食物**节点

    1. Snake内部要存储head

## 类设计

* Food
    * amount
    * color
    * ...

* Snake
    * head: SKSpriteNode 蛇头节点
    * enemies 其他所有蛇的节
    * 
    * update() 计算loss
    * 

* GameScene: SKScene
    * (internal) scene 界面类
    * snakes: [Snake]
    * foods: [Food]
    * createSnake() 创建一条蛇
        * 将蛇对象加入snakes中，将蛇的所有节点（body节点）加到scene中
        * 更新所有蛇的enemies，和新创建的蛇的enemies
        * 
    * createFood() 创建一个食物
    * (override) update() 更新界面，检查是否需要创建新的食物/蛇
        * 


## 蛇身设计

蛇头坐标

行进速度

节之间的距离

初识长度

蛇身节数

## AI设计




