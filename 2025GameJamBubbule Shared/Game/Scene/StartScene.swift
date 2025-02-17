import SpriteKit

class StartScene: SKScene {
    
    override func didMove(to view: SKView) {
        // 设置场景的缩放模式
        self.scaleMode = .aspectFit
        
        // 设置背景图片
        let background = SKSpriteNode(imageNamed: "startgb")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = self.size
        background.zPosition = 0 // 确保背景在最底层
        addChild(background)
        
        // 添加开始按钮
        setupStartButton()
        
        // 添加背景音乐
        if let musicURL = Bundle.main.url(forResource: "bgm", withExtension: "mp3") {
            let backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
    
    private func setupStartButton() {
        // 创建一个容器节点来包含按钮
        let buttonContainer = SKNode()
        buttonContainer.position = CGPoint(x: size.width/2, y: size.height/2)
        buttonContainer.zPosition = 10 // 确保在背景之上
        
        // 创建开始按钮（使用文字）
        let startButton = SKLabelNode(fontNamed: "Helvetica-Bold")
        startButton.text = "开始游戏"
        startButton.name = "startButton"
        startButton.fontSize = 48
        startButton.fontColor = .white
        startButton.verticalAlignmentMode = .center // 确保文字垂直居中
        
        // 创建一个背景节点让按钮更容易点击
        let buttonBackground = SKShapeNode(rectOf: CGSize(width: 200, height: 60))
        buttonBackground.fillColor = .clear
        buttonBackground.strokeColor = .white
        buttonBackground.alpha = 0.5
        buttonBackground.name = "startButton"
        
        // 将文字和背景添加到容器中
        buttonContainer.addChild(buttonBackground)
        buttonContainer.addChild(startButton)
        
        // 添加按钮容器到场景
        addChild(buttonContainer)
        
        // 添加按钮呼吸动画
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        buttonContainer.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if node.name == "startButton" {
                // 创建游戏场景
                let gameScene = GameScene.newGameScene()
                gameScene.scaleMode = .aspectFit
                
                // 使用转场效果
                let transition = SKTransition.fade(withDuration: 0.5)
                view?.presentScene(gameScene, transition: transition)
                return
            }
        }
    }
} 