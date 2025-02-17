//
//  GameLevel.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/21.
//

import SwiftUI

/// 定义游戏关卡的要求，如挡板属性和运行的函数。
public protocol GameLevel: AnyObject {
    var cat: Cat { get set }
    //var balls: [Ball] { get set }
    var brickCount: Int { get set }
    var difficulty: Double { get set }
    var onCompletion: (() -> Void) { get set }

    func run()
    func clear()
    //func addBall(at point: Point) -> Ball
    //func createBrick(color: Color) -> Brick
    func checkForLevelCompletion()
    
    func winLevel()
    func loseLevel()
}

// GameLevel 的默认实现方法。
extension GameLevel {
    
    public var onCompletion: (() -> Void) {
        get { return {} }
        set {}
    }
    
    public func run() {
        
    }
    
    public func checkForLevelCompletion() {
        
    }
    
    public func clear() {
//        paddle.disableHorizontalTracking(in: scene)
//        paddle.remove()
//        scene.removeGraphics(named: "ball")
//        scene.removeGraphics(named: "wall")
    }
    /*
    public func addBall(at point: Point = Point.zero) -> Ball {
//        return Ball(image: #imageLiteral(resourceName: "vollyball@2x.png"))
    }
    
    public func createBrick(color: Color) -> Brick {
//        return Brick(tint: .white)
    }*/
    
    public func winLevel() { }
    public func loseLevel() { }
}
