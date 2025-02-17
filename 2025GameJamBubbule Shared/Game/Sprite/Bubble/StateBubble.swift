import SpriteKit

/// 具有状态机制的泡泡类，用于管理泡泡的不同状态和行为
class StateBubble: BaseSprite {
    // MARK: - 属性
    
    /// 当前状态对象
    private var currentState: BubbleState
    
    /// 状态变化回调闭包类型
    typealias StateChangeHandler = (BubbleState, BubbleState) -> Void
    
    /// 状态变化监听器数组
    private var stateChangeListeners: [StateChangeHandler] = []
    
    /// 用于播放爆炸音效的节点
    private var burstSoundNode: SKAudioNode?
    
    // MARK: - 初始化方法
    override init(size: CGSize, color: UIColor) {
        let texture = SKTexture(imageNamed: "art-bubble")
        currentState = BubbleNormalState() // 初始为正常状态
        
        super.init(texture: texture, color: color, size: size)
        
        self.name = "stateBubble"
        setupPhysics()
        
//        self.addRedCircle()
        
        // 正式进入正常状态
        changeState(to: BubbleNormalState())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 物理设置
    
    override func setupPhysics() {
        // 设置圆形物理体
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.isDynamic = true         // 启用物理模拟
        self.physicsBody?.affectedByGravity = false // 不受重力影响
        self.physicsBody?.allowsRotation = true    // 允许旋转
        self.physicsBody?.linearDamping = 0.5      // 线性阻尼
        self.physicsBody?.angularDamping = 0.1     // 角速度阻尼
        self.physicsBody?.restitution = 0.7        // 弹性系数
        
        // 设置碰撞检测类别
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bubble
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Bubble // 检测与其他泡泡的碰撞
        self.physicsBody?.collisionBitMask = PhysicsCategory.Enemy // 不进行物理碰撞
    }
    
    // MARK: - 状态监听
    
    /// 添加状态变化监听器
    /// - Parameter handler: 状态变化时的回调闭包
    func addStateChangeListener(_ handler: @escaping StateChangeHandler) {
        stateChangeListeners.append(handler)
    }
    
    /// 移除所有状态变化监听器
    func removeAllStateChangeListeners() {
        stateChangeListeners.removeAll()
    }
    
    // MARK: - 状态管理
    
    /// 切换到新状态
    /// - Parameter newState: 要切换到的新状态
    func changeState(to newState: BubbleState) {
        if type(of: currentState) != type(of: newState) {
            let oldState = currentState
            currentState.exitState(bubble: self)
            currentState = newState
            currentState.enterState(bubble: self)
            
            // 通知场景状态变化
            if let scene = self.scene as? GameScene {
                if newState is BubbleNormalState {
                    scene.bubbleDidFinishScaling(self)
                }
            }
            
            // 通知所有监听器状态发生变化
            stateChangeListeners.forEach { handler in
                handler(oldState, newState)
            }
        }
    }
    
    /// 状态更新
    override func update() {
        currentState.update(bubble: self)
        updateActiveBubbleScale() // 更新 ActiveBubble 的缩放
    }
    
    // MARK: - 公共接口
    
    /// 开始放大状态
    func startScaling() {
        changeState(to: BubbleScalingState())
    }
    
    /// 结束放大状态
    func endScaling() {
        changeState(to: BubbleScalingEndState())
    }
    
    /// 触发爆炸状态
    func burst() {
        changeState(to: BubbleBurstState())
        playBurstSound()
    }
    
    // MARK: - 音效处理
    
    /// 播放爆炸音效
    private func playBurstSound() {
        if let scene = self.scene {
            AudioManager.shared.playSoundEffect(name: "bubble_burst", in: scene)
        }
    }
    
    /// 在泡泡上添加 ActiveBubble 纹理
    /// - Returns: 创建的 ActiveBubble 实例
    func addActiveBubble()  {
        
        // 创建 ActiveBubble，使用当前泡泡的大小
        let activeBubble = ActiveBubble.createCircularSprite(center: self.position,
                                                           radius: self.size.width/2)
        
        // 设置 ActiveBubble 的属性
        activeBubble.position = .zero // 相对于泡泡的中心点
        activeBubble.zPosition = 0    // 确保在泡泡下层
        
        // 抵消父节点的缩放效果
        activeBubble.setScale(1.0 / self.xScale)
        
        // 添加到当前泡泡
        self.addChild(activeBubble)
        
        //return activeBubble
    }
    
    /// 更新 ActiveBubble 的缩放
    private func updateActiveBubbleScale() {
        self.children.forEach { child in
            if let activeBubble = child as? ActiveBubble {
                // 保持 ActiveBubble 的原始大小
                activeBubble.setScale(1.0 / self.xScale)
            }
        }
    }
    
    /// 移除所有 ActiveBubble
    func removeActiveBubbles() {
        self.children.forEach { child in
            if child is ActiveBubble {
                child.removeFromParent()
            }
        }
    }
    
    /// 在泡泡上添加红色圆圈
    func addRedCircle() {
        // 创建一个圆形的 ShapeNode
        let circle = SKShapeNode(circleOfRadius: self.size.width/2)
        
        // 抵消父节点的缩放效果
        circle.setScale(1.0 / self.xScale)
        
        // 设置圆圈的属性
        circle.strokeColor = .green     // 边框颜色
        circle.lineWidth = 2.0          // 边框宽度
        circle.fillColor = .clear       // 填充颜色透明
        circle.position = .zero         // 位置在泡泡中心
        circle.zPosition = 100         // 确保显示在泡泡上层
        circle.alpha = 0.8             // 稍微透明一点
        
        // 添加到泡泡上
        self.addChild(circle)
        
        
        let maxScale = self.xScale + 0.1
        let noramlScale = self.xScale
        // 可以添加一个简单的动画效果
        let pulseAction = SKAction.sequence([
            SKAction.scale(to: maxScale, duration: 0.5),
            SKAction.scale(to: noramlScale, duration: 0.5)
        ])
        //circle.run(SKAction.repeatForever(pulseAction))
        
        //self.run(SKAction.repeatForever(pulseAction))
         
    }
    
    /// 处理与其他泡泡的碰撞
    func handleBubbleCollision() {
        // 如果当前是放大状态，则切换到结束状态
        if currentState is BubbleScalingState {
            self.endScaling()
        }
    }
    
    override func removeFromParent() {
        // 通知场景泡泡将被移除
        if let scene = self.scene as? GameScene {
            scene.bubbleWillBeRemoved(self)
        }
        super.removeFromParent()
    }
    
    /// 检查泡泡是否处于正常状态
    var isNormalState: Bool {
        return currentState is BubbleNormalState
    }
    
    override func handleCollision(with sprite: BaseSprite, at point: CGPoint) {
        // 处理与其他泡泡的碰撞
        if let otherBubble = sprite as? StateBubble {
            handleBubbleCollision()
            
            // 更新进度
            if let scene = self.scene as? GameScene {
                scene.calculateBubblesProgress()
            }
        }
        
        // 处理与敌人的碰撞
        if sprite is Enemy {
            handleEnemyCollision()
        }
    }
    
    private func handleEnemyCollision() {
        // 如果泡泡正在放大，则结束放大
        if currentState is BubbleScalingState {
            endScaling()
        }
        
        // 如果泡泡处于正常状态，则触发爆炸
        if currentState is BubbleNormalState {
            // 播放爆炸音效
            if let scene = self.scene {
                AudioManager.shared.playSoundEffect(name: "bubble_burst", in: scene)
            }
            
            // 切换到爆炸状态
            burst()
        }
    }
} 
