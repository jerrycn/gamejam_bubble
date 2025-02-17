import SpriteKit

/// Enemy 移动状态
class EnemyMoveState: EnemyState {
    private var moveTimer: TimeInterval = 0
    private let moveDuration: TimeInterval = 3.0 // 移动持续时间
    private var targetPosition: CGPoint?
    
    override func enterState(enemy: Enemy) {
        // 选择新的目标位置
        if let scene = enemy.scene {
            let randomX = CGFloat.random(in: 0...scene.size.width)
            let randomY = CGFloat.random(in: 0...scene.size.height)
            targetPosition = CGPoint(x: randomX, y: randomY)
            
            // 移动到目标位置
            if let target = targetPosition {
                enemy.moveTo(target)
            }
        }
        
        // 播放移动动画
        if let boss = enemy as? Boss {
            let moveAnimation = SKAction.animate(with: boss.moveFrames, timePerFrame: 0.1)
            boss.run(SKAction.repeatForever(moveAnimation))
        }
    }
    
    override func update(enemy: Enemy) {
        moveTimer += 1/60
        
        if moveTimer >= moveDuration {
            // 移动时间结束，切换回空闲状态
            enemy.changeState(to: EnemyIdleState())
        }
    }
    
    override func exitState(enemy: Enemy) {
        // 停止移动动画
        enemy.removeAllActions()
    }
} 