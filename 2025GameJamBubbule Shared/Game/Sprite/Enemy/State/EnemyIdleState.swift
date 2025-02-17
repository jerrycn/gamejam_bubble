import SpriteKit

/// Enemy 空闲状态
class EnemyIdleState: EnemyState {
    private var idleTimer: TimeInterval = 0
    private let idleDuration: TimeInterval = 2.0 // 空闲持续时间
    
    override func enterState(enemy: Enemy) {
        // 停止移动
        enemy.physicsBody?.velocity = .zero
        
        // 播放空闲动画
        if let boss = enemy as? Boss {
            let idleAnimation = SKAction.animate(with: boss.idleFrames, timePerFrame: 0.1)
            boss.run(SKAction.repeatForever(idleAnimation))
        }
    }
    
    override func update(enemy: Enemy) {
        idleTimer += 1/60 // 假设60帧每秒
        
        if idleTimer >= idleDuration {
            // 空闲时间结束，切换到移动状态
            enemy.changeState(to: EnemyMoveState())
        }
    }
    
    override func exitState(enemy: Enemy) {
        // 停止空闲动画
        enemy.removeAllActions()
    }
} 