//
//  Paddle.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/21.
//


import Foundation

/// “打砖块”游戏中的挡板。它从一侧移到另一侧来控制球。
class Paddle: Sprite {
    
    /*
    var collisionSound: GameSound = .warpMono
    
    /// 允许你通过触碰来回移动挡板。
    public func enableHorizontalTracking(in scene: Scene) {
        scene.trackTouch(withSprite: self)
    }
    
    /// 停用通过触碰控制挡板。
    public func disableHorizontalTracking(in scene: Scene) {
        scene.stopTrackingTouch(withSprite: self)
    }
     */
    /// 通过赋予初始值来设置挡板。
    public init(image: Image) {
        super.init(graphicType: .sprite, name: "paddle")
        /*
        self.image = image
        xScale = 2.25
        friction = 0.1
        interactionCategory = .paddle
        collisionCategories = [.ball]
        collisionNotificationCategories =  [.ball]
        
        setOnCollisionHandler { collision in
            let position = collision.spriteB.position
            self.playCollisionSound(self.collisionSound, at: position, using: self.collisionSoundSource)
        }
        disablesOnDisconnect = true*/
    }
    
    //var collisionSoundSource = Graphic(shape: .circle(radius: 4), color: .clear, name: "impact")
     
}
