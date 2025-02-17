import SpriteKit

/// 敌人基类，所有敌人类型都继承自此类
class Enemy: BaseSprite {
    // MARK: - 属性
    
    /// 敌人的生命值
    var health: Int = 100
    
    /// 敌人的移动速度
    var moveSpeed: CGFloat = 100.0
    
    /// 敌人是否存活
    var isAlive: Bool = true
    
    /// 当前状态
    private var currentState: EnemyState = EnemyIdleState()
    
    // MARK: - 初始化方法
    
    override init(size: CGSize, color: UIColor) {
        super.init(texture: nil, color: color, size: size)
        setupEnemy()
    }
    
    init(texture: SKTexture?, size: CGSize, color: UIColor) {
        super.init(texture: texture, color: color, size: size)
        setupEnemy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置方法
    
    /// 基础敌人设置
    private func setupEnemy() {
        self.name = "enemy"
        setupPhysics()
    }
    
    override func setupPhysics() {
        // 设置基础物理属性
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        
        // 设置物理碰撞属性
        self.setCategoryBitMask(PhysicsCategory.Enemy)
        self.setContactTestBitMask(PhysicsCategory.Bubble)
        self.setCollisionBitMask(PhysicsCategory.Player | PhysicsCategory.Bubble)
    }
    
    // MARK: - 公共方法
    
    /// 受到伤害
    /// - Parameter damage: 伤害值
    func takeDamage(_ damage: Int) {
        health -= damage
        if health <= 0 {
            die()
        }
    }
    
    /// 死亡处理
    func die() {
        if !(currentState is EnemyDeathState) {
            changeState(to: EnemyDeathState())
        }
    }
    
    /// 移动到指定位置
    /// - Parameter position: 目标位置
    func moveTo(_ position: CGPoint) {
        let distance = hypot(position.x - self.position.x, position.y - self.position.y)
        let duration = distance / moveSpeed
        
        let moveAction = SKAction.move(to: position, duration: TimeInterval(duration))
        self.run(moveAction)
    }
    
    /// 向指定方向移动
    /// - Parameter velocity: 速度向量
    func move(withVelocity velocity: CGVector) {
        self.physicsBody?.velocity = velocity
    }
    
    /// 切换状态
    func changeState(to newState: EnemyState) {
        currentState.exitState(enemy: self)
        currentState = newState
        currentState.enterState(enemy: self)
    }
    
    /// 被泡泡击中时的效果
    func hitByBubble() {
        // 闪烁效果
        let flash = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        
        // 震动效果
        let shake = SKAction.sequence([
            SKAction.moveBy(x: 5, y: 5, duration: 0.05),
            SKAction.moveBy(x: -5, y: -5, duration: 0.05)
        ])
        
        // 组合效果
        let hitEffect = SKAction.group([
            SKAction.repeat(flash, count: 2),
            SKAction.repeat(shake, count: 2)
        ])
        
        // 运行效果后死亡
        self.run(hitEffect) { [weak self] in
            self?.die()
        }
    }
    
    // MARK: - 更新方法
    
    /// 每帧更新
    override func update() {
        super.update()
        currentState.update(enemy: self)
    }
    
    override func handleCollision(with sprite: BaseSprite, at point: CGPoint) {
        // 检查碰撞的是否是泡泡
        if let bubble = sprite as? StateBubble {
            handleBubbleCollision(with: bubble, at: point)
        }
    }
    
    private func handleBubbleCollision(with bubble: StateBubble, at point: CGPoint) {
        // 只有泡泡处于正常状态时才会受到伤害
        if bubble.isNormalState {
            // 播放音效
            if let scene = self.scene {
                AudioManager.shared.playSoundEffect(name: "enemy_hit", in: scene)
            }
            
            // 添加击中特效
            addHitEffect(at: point)
            
            // 执行击中动画和死亡
            hitByBubble()
        }
    }
    
    private func addHitEffect(at point: CGPoint) {
        if let hitEffect = SKEmitterNode(fileNamed: "HitEffect") {
            hitEffect.position = convert(point, from: parent!)
            addChild(hitEffect)
            
            let wait = SKAction.wait(forDuration: 0.3)
            let remove = SKAction.removeFromParent()
            hitEffect.run(SKAction.sequence([wait, remove]))
        }
    }
} 
