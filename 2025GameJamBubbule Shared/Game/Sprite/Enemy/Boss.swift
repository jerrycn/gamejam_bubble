import SpriteKit

class Boss: Enemy {
    // 添加动画帧数组
    let idleFrames: [SKTexture]
    let moveFrames: [SKTexture]
    let deathFrames: [SKTexture]
    
    override init(size: CGSize, color: UIColor) {
        // 加载动画帧
        idleFrames = Boss.loadFrames(prefix: "boss_walk", count: 2)
        moveFrames = Boss.loadFrames(prefix: "boss_walk", count: 19)
        deathFrames = Boss.loadFrames(prefix: "boss_death", count: 8)
        
        super.init(texture: idleFrames[0], size: size, color: color)
        
        self.name = "boss"
        
        // 设置 Boss 特有的属性
        self.health = 200 // Boss 有更多生命值
        self.moveSpeed = 50.0 // Boss 移动更快
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupPhysics() {
        super.setupPhysics()
        
        // Boss 特有的物理属性
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.friction = 0.0
    }
    
    // Boss 特有的行为
    override func die() {
        // 播放 Boss 死亡特效
        let explosion = SKEmitterNode(fileNamed: "BossExplosion")
        explosion?.position = self.position
        self.parent?.addChild(explosion!)
        
        // 调用父类的死亡方法
        super.die()
    }
    
    private static func loadFrames(prefix: String, count: Int) -> [SKTexture] {
        var frames: [SKTexture] = []
        for i in 0..<count {
            let textureName = String(format: "\(prefix)00_%02d", i)
            frames.append(SKTexture(imageNamed: textureName))
        }
        return frames
    }
    
    /// 在场景中生成 Boss
    static func spawn(in scene: SKScene, size: CGSize) -> Boss {
        let boss = Boss(size: size, color: .red)
        scene.addChild(boss)
        boss.changeState(to: BossSpawnState())
        return boss
    }
} 
