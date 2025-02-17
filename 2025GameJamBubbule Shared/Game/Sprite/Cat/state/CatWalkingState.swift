//
//  WalkingState.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/30.
//

import SpriteKit


class CatWalkingState: CatState {
    enum MovementType { case slow, fast }
    private var speed: CGFloat
    private var direction: CGVector

    init(direction: CGVector,type: MovementType) {
        self.speed = (type == .slow) ? 50 : 150
        self.direction = direction
    }
    
    func enterState(cat: Cat) {
        // 只有当不在播放动画时才设置新的动画
        if cat.action(forKey: "walkAnimation") == nil {
            cat.run(SKAction.repeatForever(cat.walkAnimation), withKey: "walkAnimation")
        }
        
        let velocity = CGVector(dx: direction.dx * speed, dy: direction.dy * speed)
        cat.physicsBody?.velocity = velocity
        
        // 开始播放移动音效
        cat.startMovingSound()
    }
    
    func exitState(cat: Cat) {
        cat.removeAction(forKey: "walkAnimation")
        // 停止移动音效
        cat.stopMovingSound()
    }
    
    func update(cat: Cat) {
        // 可在这里处理动态加速
    }
}
