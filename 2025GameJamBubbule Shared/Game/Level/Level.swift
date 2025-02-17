//
//  Level.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/21.
//

import SwiftUI

/// “打砖块”游戏的一个关卡。
class Level: GameLevel {
    public var cat: Cat
    // 关卡的变量。
//    public var paddle : Paddle
    //public var balls : [Ball] = []
    public var ballImage : Image = Image(imageLiteralResourceName: "")
    public var paddleImage : Image = Image(imageLiteralResourceName: "")
    public var difficulty : Double = 3
    public var brickCount : Int = 0
    // 完成处理程序。
    
    
    var layout: Layout
    // 添加多条命。
    let scene:GameScene
    
    /// 创建关卡并设定其初始值。
    public init(scene:GameScene,using layout: Layout = Layout.plain()) {
        //        scene.hasCollisionBorder = true
        //        scene.backgroundImage = #imageLiteral(resourceName: "Background_1.png")
        
        self.scene = scene
        
        cat = Cat(size: CGSize(width: 60, height: 60), color: Color.clear)
        
//        paddle = Paddle(image: paddleImage)
        
        self.layout = layout
    }
    
    /// 添加挡板并设定它的值。
    func addCat() {
        cat = Cat(size: CGSize(width: 60, height: 60), color: Color.clear)
        cat.enableHorizontalTracking(in: scene)
        scene.place(cat, at: Point(x: 0, y: 0))
        
        //paddle.enableHorizontalTracking(in: scene)
        //scene.place(paddle.collisionSoundSource, at: paddle.position)
    }
    
    /// 添加挡板并设定它的值。
//    func addPaddle() {
//        paddle = Paddle(image: paddleImage)
//        paddle.bounciness = 1.05 + (0.02 * difficulty)
//        scene.place(paddle, at: Point(x: 0, y: 0))
//        //paddle.enableHorizontalTracking(in: scene)
//        //scene.place(paddle.collisionSoundSource, at: paddle.position)
//    }
    
    /// 添加所有的游戏元素并运行关卡。
    public func run() {
        
        // 添加挡板。
        addCat()
        
        // 添加球并赋予它速度。
//        let ball = addBall()
//        ball.setVelocity(x: 500, y: 500)
//        ball.spark(duration: 50, color: #colorLiteral(red: 0.807843137254902, green: 0.027450980392156862, blue: 0.3333333333333333, alpha: 1.0))
//        ball.tracer(duration: 2, color: #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0))
//
//        
//        // 添加砖块布局。
//        addBricks(layout: layout, brickMaker: createBrick(color:))
//
//        
//        // 添加墙和边线。
//        addWalls()
//
//        
//        // 添加辅助功能信息。
//        addAccessibility()
    }
    /*
    /// 使用颜色创建砖块。
    public func createBrick(color: Color) -> Brick {
        let brick = Brick(tint: color)
        
        // 砖块自定义。
        
        
        
        return brick
    }
    
    
    /// 只要打裂砖块就调用。检查是否已完成这一关。 
    public func checkForLevelCompletion() {
        brickCount -= 1
        if brickCount == 0 {
        // 调用 winLevel
            winLevel()

        }

        
    }
    
    /// 通关后调用。
    public func winLevel() {
        let reward = Label(text: "🥳", color: #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: 225, name: "reward")
        scene.place(reward, at: Point(x: 0, y: 0))
        clearLevel()
        
       
    }
    
    /// 球击中边线时调用。
    func hitFoulLine(sprite: Sprite) {
        
       
        
        
    }
    
    
    /// 这一关失败时调用。
    public func loseLevel() {
        let failure = Label(text: "😭", color: #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: 200)
        scene.place(failure, at: Point(x: 0, y: 0))
        clearLevel()
        
        
        
    }
    
    /// 添加击中后移走球的边线。
   func addFoulLine() {
        let foulLine = Wall(image: #imageLiteral(resourceName: "FoulTile@2x.png"), orientation: .horizontal)
        foulLine.scale = 1
        scene.place(foulLine, at: Point(x: 0, y: -500))
        
        foulLine.setOnCollisionHandler { collision in
            
            if collision.spriteB.name == "ball" {
                self.hitFoulLine(sprite: collision.spriteB)
            }
        }
    }
    
    
    
    /// 创建球并将它添加到球数组。
    public func addBall(at point: Point = Point.zero) -> Ball {
        let ball = Ball(image: ballImage)
        scene.place(ball, at: point)
        balls.append(ball)
        
        monitorBall()
        
        return ball
    }
     */
    
    
    
}
