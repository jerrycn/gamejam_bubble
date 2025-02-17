import SpriteKit

class VictoryScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        
        // 设置背景
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        // 创建胜利标题
        let titleLabel = SKLabelNode(fontNamed: "Arial-Bold")
        titleLabel.text = "游戏胜利！"
        titleLabel.fontSize = 48
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.7)
        addChild(titleLabel)
        
        // 创建重新开始按钮
        let restartButton = SKShapeNode(rectOf: CGSize(width: 200, height: 60), cornerRadius: 10)
        restartButton.fillColor = UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0)
        restartButton.strokeColor = .white
        restartButton.position = CGPoint(x: size.width/2, y: size.height * 0.4)
        restartButton.name = "restartButton"
        
        let restartLabel = SKLabelNode(fontNamed: "Arial")
        restartLabel.text = "重新开始"
        restartLabel.fontSize = 24
        restartLabel.fontColor = .white
        restartLabel.verticalAlignmentMode = .center
        restartButton.addChild(restartLabel)
        
        addChild(restartButton)
        
        // 添加点击动画
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        restartButton.run(SKAction.repeatForever(pulse))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if node.name == "restartButton" {
                // 重新开始游戏
                if let view = self.view {
                    let newGame = GameScene(size: self.size)
                    let transition = SKTransition.fade(withDuration: 0.5)
                    view.presentScene(newGame, transition: transition)
                }
                break
            }
        }
    }
} 