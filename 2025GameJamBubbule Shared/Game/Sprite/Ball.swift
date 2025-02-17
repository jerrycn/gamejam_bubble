//
//  Ball.swift
//  2025GameJamBubbule
//  球
//  Created by jerrylong on 2025/1/21.
//



import Foundation

/// “打砖块”游戏中的球。球可以自由移动并从砖块和挡板上反弹。
class Ball: Sprite {
    
    /// 创建球并设定其初始值。
//    public init(image: Image) {
//        super.init(graphicType: .sprite, name: "ball")
//        self.image = image
//        allowsRotation = false
//        friction = 0.08
//        drag = 0.0
//        bounciness = 1.0
//        scale = 1.5
//        interactionCategory = .ball
//        collisionCategories = [.paddle, .brick, .wall]
//        collisionNotificationCategories = []
//        disablesOnDisconnect = true
//        addAccessibility()
//    }
//    
//    /// 允许球穿过砖块。
//    public func passThroughBrick(duration: Double) {
//        interactionCategory = .oddBall
//        collisionCategories = [.paddle, .wall]
//        
//        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) {_ in
//            self.interactionCategory = .ball
//            self.collisionCategories = [.paddle, .brick, .wall]
//        }
//    }
//    
//    func addAccessibility() {
//        if Scene.shouldUsePositionalAudio {
//            addAudio(.ballBeepsMono, positional: true, looping: true, volume: 10)
//        }
//        let axLabel = Graphic.accessibilityLabelFor(for: name)
//        accessibilityHints = AccessibilityHints(makeAccessibilityElement: true, accessibilityLabel: axLabel)
//    }
}
