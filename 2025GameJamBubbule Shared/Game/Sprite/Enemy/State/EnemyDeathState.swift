import SpriteKit

/// Enemy 死亡状态
class EnemyDeathState: EnemyState {
    override func enterState(enemy: Enemy) {
        // 停止所有动作
        enemy.removeAllActions()
        
        // 播放死亡动画
        if let boss = enemy as? Boss {
            let deathAnimation = SKAction.animate(with: boss.deathFrames, timePerFrame: 0.1)
            let fadeOut = SKAction.fadeOut(withDuration: 0.3)
            let remove = SKAction.removeFromParent()
            
            boss.run(SKAction.sequence([deathAnimation, fadeOut, remove]))
        } else {
            // 普通敌人的死亡效果
            enemy.die()
        }
    }
} 