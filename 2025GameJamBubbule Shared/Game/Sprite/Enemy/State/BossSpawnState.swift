import SpriteKit

/// Boss 生成状态
class BossSpawnState: EnemyState {
    private enum SpawnSide: Int {
        case top = 0
        case right = 1
        case bottom = 2
        case left = 3
    }
    
    override func enterState(enemy: Enemy) {
        guard let boss = enemy as? Boss,
              let scene = enemy.scene else { return }
        
        // 设置生成位置和速度
        let (position, velocity) = calculateSpawnPosition(for: scene.size)
        boss.position = position
        boss.move(withVelocity: velocity)
        
        // 播放生成动画
        let spawnAnimation = SKAction.sequence([
            SKAction.scale(to: 0.1, duration: 0),
            SKAction.fadeOut(withDuration: 0),
            SKAction.group([
                SKAction.fadeIn(withDuration: 0.3),
                SKAction.scale(to: 1.0, duration: 0.3)
            ])
        ])
        
        boss.run(spawnAnimation) {
            // 生成完成后切换到移动状态
            boss.changeState(to: EnemyMoveState())
        }
        
        addSpawnEffect(to: boss)
        playSpawnSound(in: scene)
    }
    
    private func calculateSpawnPosition(for sceneSize: CGSize) -> (position: CGPoint, velocity: CGVector) {
        let side = SpawnSide(rawValue: Int.random(in: 0...3)) ?? .top
        var position: CGPoint
        var velocity: CGVector
        
        switch side {
        case .top:
            position = CGPoint(x: CGFloat.random(in: 0...sceneSize.width),
                             y: sceneSize.height + 50)
            velocity = CGVector(dx: CGFloat.random(in: -100...100), dy: -150)
            
        case .right:
            position = CGPoint(x: sceneSize.width + 50,
                             y: CGFloat.random(in: 0...sceneSize.height))
            velocity = CGVector(dx: -150, dy: CGFloat.random(in: -100...100))
            
        case .bottom:
            position = CGPoint(x: CGFloat.random(in: 0...sceneSize.width),
                             y: -50)
            velocity = CGVector(dx: CGFloat.random(in: -100...100), dy: 150)
            
        case .left:
            position = CGPoint(x: -50,
                             y: CGFloat.random(in: 0...sceneSize.height))
            velocity = CGVector(dx: 150, dy: CGFloat.random(in: -100...100))
        }
        
        return (position, velocity)
    }
    
    private func addSpawnEffect(to boss: Boss) {
        // 创建粒子效果
        if let spawnEffect = SKEmitterNode(fileNamed: "BossSpawn") {
            spawnEffect.position = .zero
            boss.addChild(spawnEffect)
            
            // 效果持续时间后移除
            let wait = SKAction.wait(forDuration: 0.3)
            let remove = SKAction.removeFromParent()
            spawnEffect.run(SKAction.sequence([wait, remove]))
        }
    }
    
    private func playSpawnSound(in scene: SKScene) {
        AudioManager.shared.playSoundEffect(name: "boss_spawn", in: scene)
    }
} 