import SpriteKit

class PauseScene: SKSpriteNode {
    // 回调闭包
    var onResume: (() -> Void)?
    var onRestart: (() -> Void)?
    var onMusicToggle: ((Bool) -> Void)?
    var onSoundToggle: ((Bool) -> Void)?
    
    // 音乐和音效状态
    private var isMusicOn: Bool = true
    private var isSoundOn: Bool = true
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.black.withAlphaComponent(0.5), size: size)
        self.isUserInteractionEnabled = true // 允许接收点击事件
        
        // 从 UserDefaults 获取当前状态
        isMusicOn = UserDefaults.standard.bool(forKey: "BackgroundMusicEnabled")
        isSoundOn = UserDefaults.standard.bool(forKey: "SoundEffectsEnabled")
        
        // 添加一个透明的背景层来拦截所有点击
        let touchInterceptor = SKShapeNode(rectOf: size)
        touchInterceptor.fillColor = .clear // 完全透明
        touchInterceptor.strokeColor = .clear
        touchInterceptor.position = CGPoint(x: size.width/2, y: size.height/2)
        touchInterceptor.name = "touchInterceptor"
        addChild(touchInterceptor)
        
        // 半透明背景
        let background = SKShapeNode(rectOf: size)
        background.fillColor = UIColor(white: 0, alpha: 0.7)
        background.strokeColor = .clear
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(background)
        
        // 暂停标题
        let titleLabel = SKLabelNode(fontNamed: "Arial-Bold")
        titleLabel.text = "游戏暂停"
        titleLabel.fontSize = 48
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.7)
        addChild(titleLabel)
        
        // 创建按钮
        let buttonSize = CGSize(width: 200, height: 60)
        let buttonSpacing: CGFloat = 80
        
        // 继续按钮
        let resumeButton = createButton(text: "继续游戏", size: buttonSize)
        resumeButton.position = CGPoint(x: size.width/2, y: size.height * 0.5)
        resumeButton.name = "resumeButton"
        addChild(resumeButton)
        
        // 重新开始按钮
        let restartButton = createButton(text: "重新开始", size: buttonSize)
        restartButton.position = CGPoint(x: size.width/2, y: size.height * 0.5 - buttonSpacing)
        restartButton.name = "restartButton"
        addChild(restartButton)
        
        // 音乐开关
        let musicButton = createToggleButton(text: "音乐", isOn: isMusicOn, size: buttonSize)
        musicButton.position = CGPoint(x: size.width/2, y: size.height * 0.5 - buttonSpacing * 2)
        musicButton.name = "musicButton"
        addChild(musicButton)
        
        // 音效开关
        let soundButton = createToggleButton(text: "音效", isOn: isSoundOn, size: buttonSize)
        soundButton.position = CGPoint(x: size.width/2, y: size.height * 0.5 - buttonSpacing * 3)
        soundButton.name = "soundButton"
        addChild(soundButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton(text: String, size: CGSize) -> SKNode {
        let button = SKShapeNode(rectOf: size, cornerRadius: 10)
        button.fillColor = UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0)
        button.strokeColor = .white
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = text
        label.fontSize = 24
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        return button
    }
    
    private func createToggleButton(text: String, isOn: Bool, size: CGSize) -> SKNode {
        let button = SKShapeNode(rectOf: size, cornerRadius: 10)
        button.fillColor = isOn ? UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0) : 
                                 UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)
        button.strokeColor = .white
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "\(text): \(isOn ? "开" : "关")"
        label.fontSize = 24
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        return button
    }
    
    func handleTouch(at point: CGPoint) {
        let touchedNodes = nodes(at: point)
        for node in touchedNodes {
            switch node.name {
            case "resumeButton":
                onResume?()
            case "restartButton":
                onRestart?()
            case "musicButton":
                isMusicOn.toggle()
                onMusicToggle?(isMusicOn)
                if let button = node as? SKShapeNode {
                    updateToggleButton(button, text: "音乐", isOn: isMusicOn)
                }
            case "soundButton":
                isSoundOn.toggle()
                onSoundToggle?(isSoundOn)
                if let button = node as? SKShapeNode {
                    updateToggleButton(button, text: "音效", isOn: isSoundOn)
                }
            default:
                break
            }
        }
    }
    
    private func updateToggleButton(_ button: SKShapeNode, text: String, isOn: Bool) {
        button.fillColor = isOn ? UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0) : 
                                 UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)
        if let label = button.children.first as? SKLabelNode {
            label.text = "\(text): \(isOn ? "开" : "关")"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 阻止事件继续传递
        event?.allTouches?.forEach { touch in
            touch.location(in: self)
        }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        handleTouch(at: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 阻止事件继续传递
        event?.allTouches?.forEach { touch in
            touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 阻止事件继续传递
        event?.allTouches?.forEach { touch in
            touch.location(in: self)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 阻止事件继续传递
        event?.allTouches?.forEach { touch in
            touch.location(in: self)
        }
    }
} 
