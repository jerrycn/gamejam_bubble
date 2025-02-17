//
//  GameMain.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/22.
//

import SpriteKit

/// GameScene 的主要功能扩展，包含游戏初始化和主要功能实现
extension GameScene {
    
    /// 场景的公共初始化方法，设置基础场景属性和添加必要的游戏元素
    func commonInit() {
        // 初始化物理世界
        physicsWorldInit()
        
        // 设置场景锚点为左下角，这样所有元素都以屏幕中心为参考点
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        // 添加游戏背景
        addBackground()
        
        // 初始化背景音乐
        AudioManager.shared.setupBackgroundMusic(in: self)
        
        // 创建初始的大泡泡
        //self.setupActiveBubble(centerPoint: sceneCenterPoint, radius: 120)
        
        // 开始生成 Boss
        self.startSpawningBosses()
        
        // 添加 UI 界面层
        addUIOverlay()
        
        // 添加暂停按钮
        addPauseButton()
        
    }
    
    
   
    
    /// 游戏主要运行逻辑
    func main() {
        // 创建第一关
        let level1 = Level(scene: self)
        
        // 创建游戏实例并运行
        let game = Game(levels: [level1])
        game.run()
    }
    
    /// 在场景中放置精灵
    /// - Parameters:
    ///   - graphic: 要放置的精灵
    ///   - at: 放置位置
    ///   - anchoredTo: 锚点位置
    public func place(_ graphic: BaseSprite, at: Point, anchoredTo: AnchorPoint = .center) {
        graphic.position = CGPoint(x: 300, y: 300)
        graphic.zPosition = 100000
        self.addChild(graphic)
    }
    
    /// 添加游戏背景
    func addBackground() {
        let bg = Background(size: self.size, color: .green)
        bg.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        bg.position = CGPoint.zero // 因为锚点在中心，所以位置为 0
        bg.zPosition = -1 // 确保背景在最底层
        self.addChild(bg)
    }
    
    /// 创建一个新的状态泡泡
    /// - Parameters:
    ///   - position: 泡泡的创建位置
    ///   - color: 泡泡的颜色
    /// - Returns: 创建的状态泡泡实例
    func makeBubble(at position: CGPoint, color: UIColor) -> StateBubble? {
        // 检查是否有正在放大的泡泡
        let scalingBubbles = self.children.filter { $0.name == "scaling_bubble" }
        let normalBubbles = self.children.filter { $0.name == "stateBubble" }
        
        // 如果没有正在放大的泡泡，就可以创建新泡泡
        if scalingBubbles.isEmpty {
            let bubble = StateBubble(size: CGSize(width: 50, height: 50), color: color)
        bubble.position = position
        bubble.zPosition = 100
        
        // 设置物理属性
        bubble.setupPhysics()
        bubble.setCategoryBitMask(PhysicsCategory.MaskBubbles)
        bubble.setContactTestBitMask(PhysicsCategory.Enemy | PhysicsCategory.Brick)
        bubble.setCollisionBitMask(PhysicsCategory.Enemy | PhysicsCategory.Brick)
        
            self.addChild(bubble)
            bubble.startScaling() // 开始放大状态
        
            return bubble
        }
        return nil
    }
    
    /// 开始生成 Boss 的循环
    func startSpawningBosses() {
        // 创建生成 Boss 的动作
        let spawnAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            
            let currentBosses = self.children.filter { $0.name == "boss" }.count
            if currentBosses < 3 { // 限制最多3个 Boss
                _ = Boss.spawn(in: self, size: CGSize(width: 80, height: 80))
            }
        }
        
        // 设置生成间隔
        let waitAction = SKAction.wait(forDuration: TimeInterval.random(in: 5...8))
        let spawnSequence = SKAction.sequence([spawnAction, waitAction])
        
        // 改为无限循环生成，而不是只生成3次
        self.run(SKAction.repeatForever(spawnSequence), withKey: "spawnBosses")
    }
    
    /// 进度条类
    class ProgressBar: SKNode {
        private let backgroundBar: SKShapeNode
        private let progressBar: SKShapeNode
        private var progress: CGFloat = 0.2 // 初始进度20%
        
        init(size: CGSize) {
            // 创建背景条
            backgroundBar = SKShapeNode(rectOf: size)
            backgroundBar.fillColor = UIColor(white: 0.3, alpha: 0.3)
            backgroundBar.strokeColor = .clear
            
            // 创建进度条
            let progressWidth = size.width * progress
            let progressSize = CGSize(width: size.width, height: size.height) // 修改为全宽
            progressBar = SKShapeNode(rectOf: progressSize)
            progressBar.fillColor = UIColor(white: 0.8, alpha: 0.5)
            progressBar.strokeColor = .clear
            
            super.init()
            self.name = "gameProgressBar"
            
            addChild(backgroundBar)
            addChild(progressBar)
            
            // 初始化进度条位置和缩放
            progressBar.position = .zero
            updateProgress(progress)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// 设置进度值（0-1）
        func setProgress(_ value: CGFloat) {
            updateProgress(value)
        }
        
        private func updateProgress(_ value: CGFloat) {
            progress = min(max(value, 0), 1)
            print("设置进度条值: \(progress * 100)%")
            
            // 使用缩放来显示进度
            progressBar.xScale = progress
            
            // 调整位置，使进度条从左边开始增长
            let offset = (backgroundBar.frame.width * (1 - progress)) / 2
            progressBar.position.x = -offset
        }
    }
    
    /// 添加 UI 界面层
    func addUIOverlay() {
        let uiTexture = SKTexture(imageNamed: "art-ui-1")
        let uiOverlay = SKSpriteNode(texture: uiTexture)
        
        uiOverlay.size = self.size
        uiOverlay.zPosition = 1000000 // UI 层在最上层
        uiOverlay.position = CGPoint.zero
        uiOverlay.anchorPoint = CGPoint.zero
        self.addChild(uiOverlay)
        
        // 创建进度条
        let progressBarHeight: CGFloat = 80
        let progressBarSize = CGSize(width: self.size.width, height: progressBarHeight)
        let progressBar = ProgressBar(size: progressBarSize)
        
        // 设置进度条位置在底部
        progressBar.position = CGPoint(x: self.size.width/2,
                                     y: progressBarHeight/2)
        progressBar.zPosition = uiOverlay.zPosition + 1 // 确保在UI层上面
        
        self.addChild(progressBar)
    }
    
    /// 在场景中创建大泡泡
    /// - Parameters:
    ///   - centerPoint: 泡泡的中心点
    ///   - radius: 泡泡的半径
    func setupActiveBubble(centerPoint: CGPoint, radius: CGFloat) {
        // 创建固定大小的 ActiveBubble
        let activeBubble = ActiveBubble.createCircularSprite(center: centerPoint, radius: radius-5)
        
        // 设置位置和层级
        activeBubble.position = centerPoint
        activeBubble.zPosition = 1 // 确保在适当的层级显示
        
        self.addChild(activeBubble)
    }
    
    /// 计算所有泡泡的总面积占场景的比例
    func calculateBubblesProgress() -> CGFloat {
        // 只获取正常状态的泡泡（不包括正在放大的泡泡）
        let bubbles = self.children.filter { node in 
            if let bubble = node as? StateBubble {
                // 只计算已完成放大的泡泡
                return bubble.name == "stateBubble"
            }
            return false
        }
        
        // 计算有效游戏区域（排除底部UI区域）
        let progressBarHeight: CGFloat = 80
        let effectiveHeight = self.size.height - progressBarHeight
        let effectiveArea = self.size.width * effectiveHeight
        
        // 计算所有泡泡的总面积
        let totalBubblesArea = bubbles.reduce(0.0) { sum, node in
            guard let bubble = node as? StateBubble else { return sum }
            
            // 获取泡泡实际显示的半径（考虑缩放）
            let radius = (bubble.size.width/2) * 2.5
            let area = .pi * radius * radius
            
            // 调试信息
            print("泡泡 \(bubble.name ?? "unknown"): 位置(\(bubble.position)), 半径: \(radius), 面积: \(area)")
            
            return sum + area
        }
        
        // 计算占比并限制最大值
        let progress = min(totalBubblesArea / effectiveArea, 1.0)
        
        // 调试信息
        print("有效泡泡数量: \(bubbles.count)")
        print("有效游戏区域: \(effectiveArea)")
        print("泡泡总面积: \(totalBubblesArea)")
        print("覆盖比例: \(progress * 100)%")
        
        // 更新进度条
        if let progressBar = self.childNode(withName: "gameProgressBar") as? ProgressBar {
            progressBar.setProgress(progress)
            
            // 检查胜利条件
            if progress >= 1.0 {
                handleLevelComplete()
            }
        }
        
        return progress
    }
    
    /// 将静态变量移到扩展级别
    private static var hasCompleted = false
    
    /// 处理关卡完成
    private func handleLevelComplete() {
        // 防止重复触发
        if GameScene.hasCompleted { return }
        
        GameScene.hasCompleted = true
        print("游戏胜利！")
        
        // 创建胜利场景
        let victoryScene = VictoryScene(size: self.size)
        victoryScene.scaleMode = .aspectFill
        
        // 使用淡入效果切换到胜利场景
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(victoryScene, transition: transition)
    }
}

/// 触摸处理相关的扩展
extension GameScene {
    /// 设置触摸移动的处理函数
    public func setOnTouchMovedHandler(_ handler: ((Touch) -> Void)?) {
        onTouchMovedHandler = handler
    }
    
    /// 跟踪精灵的触摸
    public func trackTouch(withSprite sprite: BaseSprite) {
        var lastTouchOrNil: Point?

        setOnTouchMovedHandler { [unowned self] (touch) in
            defer { lastTouchOrNil = touch.position }
            sprite.touch(touch: touch)
        }
    }

    /// 停止跟踪精灵的触摸
    func stopTrackingTouch(withSprite: Sprite) {
        setOnTouchMovedHandler(nil)
    }
    
    /// 处理触摸事件
    /// - Parameters:
    ///   - at: 触摸位置
    ///   - firstTouch: 是否是第一次触摸
    ///   - ignoreNode: 是否忽略节点
    ///   - doubleTouch: 是否是双击
    ///   - lastTouch: 是否是最后一次触摸
    func handleTouch(at: CGPoint, firstTouch: Bool = false, ignoreNode: Bool = false, doubleTouch: Bool = false, lastTouch: Bool = false) {
        var touch = Touch(position: Point(at), previousPlaceDistance: 0, firstTouch: firstTouch, touchedGraphic: nil, capturedGraphicID: "")
        
        touch.lastTouch = lastTouch
        touch.doubleTouch = doubleTouch
        touch.lastTouchInGraphic = lastTouch
        touch.firstTouchInGraphic = firstTouch
        
        self.onTouchMovedHandler?(touch)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func physicsWorldInit() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self // 设置碰撞检测代理
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // 获取碰撞的两个节点，并确保它们是 BaseSprite
        guard let spriteA = bodyA.node as? BaseSprite,
              let spriteB = bodyB.node as? BaseSprite else { return }
        
        // 让两个精灵各自处理碰撞
        spriteA.handleCollision(with: spriteB, at: contact.contactPoint)
        spriteB.handleCollision(with: spriteA, at: contact.contactPoint)
    }
}

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // 每秒更新一次进度（而不是每帧）
        if let lastUpdate = lastProgressUpdate {
            let timeSinceLastUpdate = currentTime - lastUpdate
            if timeSinceLastUpdate >= 1.0 {
                calculateBubblesProgress()
                lastProgressUpdate = currentTime
            }
        } else {
            lastProgressUpdate = currentTime
        }
    }
    
    private var lastProgressUpdate: TimeInterval? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.lastUpdateKey) as? TimeInterval }
        set { objc_setAssociatedObject(self, &AssociatedKeys.lastUpdateKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

private struct AssociatedKeys {
    static var lastUpdateKey = "lastProgressUpdate"
}

// 在以下时机调用进度更新：

// 1. 泡泡完成放大时
extension GameScene {
    func bubbleDidFinishScaling(_ bubble: StateBubble) {
        calculateBubblesProgress()
    }
}

// 2. 泡泡被移除时
extension GameScene {
    func bubbleWillBeRemoved(_ bubble: StateBubble) {
        calculateBubblesProgress()
    }
}

extension GameScene {
    /// 添加暂停按钮
    func addPauseButton() {
        let pauseButton = SKShapeNode(circleOfRadius: 25)
        pauseButton.fillColor = UIColor(white: 0.3, alpha: 0.5)
        pauseButton.strokeColor = .white
        // 修改位置到右上角
        pauseButton.position = CGPoint(x: self.size.width - 50, y: self.size.height - 50)
        pauseButton.name = "pauseButton"
        
        let pauseSymbol = SKShapeNode(rect: CGRect(x: -7, y: -10, width: 5, height: 20))
        pauseSymbol.fillColor = .white
        pauseSymbol.strokeColor = .clear
        pauseButton.addChild(pauseSymbol)
        
        let pauseSymbol2 = SKShapeNode(rect: CGRect(x: 2, y: -10, width: 5, height: 20))
        pauseSymbol2.fillColor = .white
        pauseSymbol2.strokeColor = .clear
        pauseButton.addChild(pauseSymbol2)
        
        pauseButton.zPosition = 1000001 // 确保在UI层之上
        self.addChild(pauseButton)
    }
    
    // 添加触摸处理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if node.name == "pauseButton" {
                showPauseScene()
                return
            }
            print("node.name=\(node.name)")
        }
        
        
        
        // 处理其他触摸事件...
        handleTouch(at: location, firstTouch: true)
    }
    
    /// 显示暂停页面
    func showPauseScene() {
        print("----showPauseScene---")
        let pauseScene = PauseScene(size: self.size)
        pauseScene.name = "pauseScene"
        pauseScene.zPosition = 1000002
        
        // 设置回调
        pauseScene.onResume = { [weak self] in
            self?.resumeGame()
        }
        
        pauseScene.onRestart = { [weak self] in
            self?.restartGame()
        }
        
        pauseScene.onMusicToggle = { [weak self] isOn in
            self?.toggleBackgroundMusic(isOn)
        }
        
        pauseScene.onSoundToggle = { [weak self] isOn in
            self?.toggleSoundEffects(isOn)
        }
        
        // 先添加暂停场景，再暂停游戏
        self.addChild(pauseScene)
        self.isPaused = true
        
        // 确保暂停场景不受游戏暂停影响
        pauseScene.isPaused = false
    }
    
    /// 继续游戏
    private func resumeGame() {
        self.isPaused = false
        if let pauseScene = self.childNode(withName: "pauseScene") {
            pauseScene.removeFromParent()
        }
    }
    
    /// 重新开始游戏
    private func restartGame() {
        if let view = self.view {
            let newGame = GameScene(size: self.size)
            let transition = SKTransition.fade(withDuration: 0.5)
            view.presentScene(newGame, transition: transition)
        }
    }
    
    /// 切换背景音乐
    private func toggleBackgroundMusic(_ isOn: Bool) {
        AudioManager.shared.toggleBackgroundMusic(isOn)
    }
    
    /// 切换音效
    private func toggleSoundEffects(_ isOn: Bool) {
        AudioManager.shared.toggleSoundEffects(isOn)
    }
}
