import SwiftUI
import SpriteKit

enum BossState {
    case idle          // 待机
    case chasing       // 追逐
    case selfDestruct  // 自爆
}

public class Boss2: BaseSprite {
    
    var currentState: BossState = .idle
    private var idleTime : CGFloat = 0
    
    var walkTextures: [SKTexture] = []
    var explosionTextures: [SKTexture] = []
    
    private var moveSpeed: CGFloat = 100.0
    
    // 泡泡的基本初始化
    override init(size: CGSize, color: UIColor) {
        let texture = SKTexture(imageNamed: "boss_walk00_00")
        super.init(texture: texture, color: color, size: size)
        
        self.name = "boss"
        setupPhysics()
        
        // 设置物理属性
        self.setCategoryBitMask(PhysicsCategory.Bubble)
        self.setContactTestBitMask(PhysicsCategory.Player) // 只检测与玩家的碰撞
        self.setCollisionBitMask(0) // 不与任何物体发生物理碰撞，我们用代码控制反弹
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        
        // 初始化动画
        setupAnimations()
        playWalkAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAnimations() {
        // 行走动画
        walkTextures = (0...19).map { i in
            SKTexture(imageNamed: String(format: "boss_walk00_%02d", i))
        }
        
        // 爆炸动画
        explosionTextures = (0...17).map { i in
            SKTexture(imageNamed: String(format: "zibao001%02d", i))
        }
    }
    
    // 移动泡泡，模拟泡泡下落
    func fall(duration: TimeInterval) {
        let moveAction = SKAction.moveBy(x: 0, y: -UIScreen.main.bounds.height, duration: duration)
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    // 设置方向力
    func applyDirectionForce() {
        // 假设我们想要让泡泡朝右上方移动
        let direction = CGVector(dx: 0, dy: 100) // 向右上方施加一个力
        self.physicsBody?.applyForce(direction)
    }
    
    
    // 待机行为
    func idleBehavior(time:TimeInterval) {
        // 可能是播放待机动画或者等待玩家接近
        print("Boss is idle.")
        self.idleTime += time 
        if (self.idleTime > 1115.0){
            playDestructAnimation()
        }
        // 比如，距离玩家足够近时切换到追逐状态
        
    }
    
    func chasingBehavior() {
        // 可能是播放待机动画或者等待玩家接近
        print("Boss is idle.")
    }
    
    func selfDestructBehavior() {
        // 可能是播放待机动画或者等待玩家接近
        print("Boss is Destruc.")
    }
    
    // 处理与玩家的碰撞
    override func didBeginContact(_ contact: BaseSprite?) {
        if contact?.name == "cat" {
            explode()
        }
    }
    
    // 爆炸效果
    func explode() {
        // 停止移动
        self.physicsBody?.velocity = .zero
        self.physicsBody?.isDynamic = false
        
        // 播放爆炸动画
        let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
        let removeAction = SKAction.removeFromParent()
        
        // 播放爆炸音效
        let soundAction = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
        
        // 执行动画序列
        self.run(SKAction.sequence([soundAction, explosionAnimation, removeAction]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // 保持恒定速度
        if let velocity = self.physicsBody?.velocity {
            let speed: CGFloat = 150.0
            let length = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
            if length > 0 {
                self.physicsBody?.velocity = CGVector(
                    dx: velocity.dx / length * speed,
                    dy: velocity.dy / length * speed
                )
            }
        }
        
        // 根据移动方向调整朝向
        if let velocity = self.physicsBody?.velocity {
            self.zRotation = atan2(velocity.dy, velocity.dx)
        }
        
        // 检查是否碰到屏幕边界并反弹
        if let scene = self.scene {
            let margin: CGFloat = 20.0
            
            if position.x <= margin {
                position.x = margin
                physicsBody?.velocity.dx = abs(physicsBody?.velocity.dx ?? 0)
            } else if position.x >= scene.size.width - margin {
                position.x = scene.size.width - margin
                physicsBody?.velocity.dx = -abs(physicsBody?.velocity.dx ?? 0)
            }
            
            if position.y <= margin {
                position.y = margin
                physicsBody?.velocity.dy = abs(physicsBody?.velocity.dy ?? 0)
            } else if position.y >= scene.size.height - margin {
                position.y = scene.size.height - margin
                physicsBody?.velocity.dy = -abs(physicsBody?.velocity.dy ?? 0)
            }
        }
        
        /*
        switch currentState {
        case .idle:
            idleBehavior(time:currentTime)
        case .chasing:
            chasingBehavior()
        case .selfDestruct:
            selfDestructBehavior()
        }*/
    }
    
    //播放动画
    func playWalkAnimation(){
        
        // 创建动画动作，设置每一帧显示的时间
        let walkAnimation = SKAction.animate(with: walkTextures, timePerFrame: 0.1)
        
        // 让玩家精灵执行动画
        self.run(SKAction.repeatForever(walkAnimation)) 
    }
    
    //播放动画
    func playDestructAnimation(){
       
        // 创建动画动作，设置每一帧显示的时间
        let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
        
        // 让玩家精灵执行动画
        self.run(SKAction.repeatForever(explosionAnimation)) 
    }
    
}
