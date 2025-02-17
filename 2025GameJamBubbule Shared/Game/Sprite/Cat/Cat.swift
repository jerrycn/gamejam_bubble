//
//  Player 2.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/26.
//

import SpriteKit


public class Cat: BaseSprite {
    
    let walkAnimation: SKAction!   //走路
    var blowAnimation: SKAction!   //吹气泡
    
    // 当前状态
    private var currentState: CatState = CatIdleState()
    
    // 添加音效节点属性
    private var blowingSoundNode: SKAudioNode?
    
    private var currentBubble: StateBubble? // 添加当前泡泡的引用
    
    // 添加移动音效节点属性
    private var movingSoundNode: SKAudioNode?
    
    // 添加一个标记来追踪移动状态
    private var isMoving: Bool = false
    
    // 初始化方法，传入圆形半径和颜色
    override init(size: CGSize, color: UIColor) {
        let texture = SKTexture(imageNamed: "cat_walk00_00")
        
        // 加载所有帧的图像
        var walkTextures: [SKTexture] = []
        
        for i in 0...14 {  // 从 cat_walk00_00 到 cat_walk00_14
            let textureName = String(format: "cat_walk00_%02d", i)
            walkTextures.append(SKTexture(imageNamed: textureName))
        }
        
        // 创建动画动作，设置每一帧显示的时间
        walkAnimation = SKAction.animate(with: walkTextures, timePerFrame: 0.1)
        
        
        // 加载所有帧的图像
        var blowTextures: [SKTexture] = []
        
        for i in 0...9 {  // 从 cat_walk00_00 到 cat_walk00_14
            let textureName = String(format: "cat_chuiqi00_%02d", i)
            blowTextures.append(SKTexture(imageNamed: textureName))
        }
        // 创建动画动作，设置每一帧显示的时间
        blowAnimation = SKAction.animate(with: blowTextures, timePerFrame: 0.1)
        
        
        super.init(texture: texture, color: color, size: size)
        
        self.name = "cat"
        
        self.setupPhysics()
        self.setCategoryBitMask(PhysicsCategory.Player)
        self.setContactTestBitMask(PhysicsCategory.Bubble | PhysicsCategory.Brick)
        self.setCollisionBitMask(PhysicsCategory.Enemy)
        
        changeState(to: CatIdleState())
    }
    
    /// 允许你通过触碰来回移动挡板。
    func enableHorizontalTracking(in scene: GameScene) {
        scene.trackTouch(withSprite: self)
    }
    
    func changeState(to newState: CatState) {
        // 只有当真正需要切换状态时才执行
        if type(of: currentState) != type(of: newState) {
            // 如果不是切换到吹泡泡状态,就停止当前泡泡
            if !(newState is CatBlowingState) {
                stopCurrentBubble()
            }
            
            currentState.exitState(cat: self)
            currentState = newState
            currentState.enterState(cat: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //按下屏幕
    override func touch(touch: Touch) {
        if currentBubble != nil {
            // 如果已经有泡泡在放大,则停止放大并切换状态
            stopCurrentBubble()
            changeState(to: CatIdleState())
            return
        }
        
        print("---touch---")
        // 计算方向
        let dx = touch.position.x - self.position.x
        let dy = touch.position.y - self.position.y
        let magnitude = sqrt(dx * dx + dy * dy)
        
        guard magnitude > 0 else { return }
        
        let velocity = CGVector(dx: (dx / magnitude),
                              dy: (dy / magnitude))
        
        let walkState = CatWalkingState(direction: velocity, type: .fast)
        changeState(to: walkState)
        
        if touch.lastTouch {
            // 检查猫的位置是否在泡泡内
            if let scene = self.parent as? GameScene {
                let catPosition = self.position
                let nodesAtCatPosition = scene.nodes(at: catPosition)
                
                // 检查猫所在位置是否有泡泡
                let hasBubble = nodesAtCatPosition.contains { node in
                    return node is StateBubble
                }
                
                if hasBubble {
                    // 如果在泡泡内，切换到空闲状态
                    changeState(to: CatIdleState())
                } else {
                    // 如果不在泡泡内，切换到吹泡泡状态
                    changeState(to: CatBlowingState())
                    fireBubble(pos: touch.position)
                }
            }
        }
    }
    
    // 发射泡泡
    func fireBubble(pos: Point) {
        if let scene = self.parent as? GameScene {
            // 创建并保存对当前泡泡的引用
            currentBubble = scene.makeBubble(at: self.position, color: .cyan)
            // 在需要监听状态变化的地方添加监听器
            currentBubble?.addStateChangeListener { (oldState, newState) in
                print("泡泡状态从 \(type(of: oldState)) 变为 \(type(of: newState))")
                
                // 可以根据不同的状态组合执行不同的操作
                if oldState is BubbleScalingState && newState is BubbleScalingEndState {
                    print("泡泡完成放大")
                    self.stopCurrentBubble()
                    self.changeState(to: CatIdleState())
                }
            }
        }
    }
    
    // 停止当前泡泡的放大
    func stopCurrentBubble() {
        if let bubble = currentBubble {
            // 切换到放大结束状态
            bubble.removeAllStateChangeListeners()
            bubble.endScaling()
            
            // 清除引用，这样下次可以创建新泡泡
            currentBubble = nil
        }
    }
    
    // 开始吹泡泡时播放音效
    func startBlowingSound() {
        if let scene = self.scene {
            AudioManager.shared.playSoundEffect(name: "bubbule_blowing", in: scene)
        }
    }
    
    // 开始移动时播放音效
    func startMovingSound() {
        if let scene = self.scene {
            AudioManager.shared.playSoundEffect(name: "cat_move", in: scene)
        }
    }
    
    // 停止声音的方法可以删除，因为 AudioManager 会自动管理音效的停止
    func stopBlowingSound() {}
    func stopMovingSound() {}
    
    override func setupPhysics() {
        // 设置物理体
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true         // 启用物理模拟
        self.physicsBody?.affectedByGravity = false // 不受重力影响
        self.physicsBody?.allowsRotation = false   // 禁止旋转
        
        // 设置物理碰撞属性
        self.setCategoryBitMask(PhysicsCategory.Player)
        self.setContactTestBitMask(PhysicsCategory.Bubble | PhysicsCategory.Brick)
        self.setCollisionBitMask(PhysicsCategory.Enemy | PhysicsCategory.Bubble)
    }
    
}
