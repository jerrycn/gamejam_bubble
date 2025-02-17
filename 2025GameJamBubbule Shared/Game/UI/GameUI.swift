import SwiftUI

import SpriteKit

class GameUI {
    public var scene: SKScene
    private var scoreLabel: SKLabelNode!
    private var logLabel: SKLabelNode!
    
    init(scene: SKScene) {
        self.scene = scene
        setupUI()
    }
    
    private func setupUI() {
        // 分数标签
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 150)
        scoreLabel.text = "Score: 0"
        scene.addChild(scoreLabel)
        
        // 日志标签
        logLabel = SKLabelNode(fontNamed: "Helvetica")
        logLabel.fontSize = 18
        logLabel.fontColor = .yellow
        logLabel.position = CGPoint(x: 150 / 2, y: 20)
        logLabel.text = "Game Started!"
        scene.addChild(logLabel)
        
        let texture = SKTexture(imageNamed: "art-ui-1")
        let artui = SKSpriteNode(texture: texture)
        artui.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        // 设置精灵的大小与屏幕大小相同
        artui.size = CGSize(width: scene.size.width, height: scene.size.height)
        scene.addChild(artui)
        
        
    }
    
    
    // 更新分数
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    // 更新日志
    func updateLog(_ message: String) {
        logLabel.text = message
    }
    
    // 清除日志
    func clearLog() {
        logLabel.text = ""
    }
    
    func gameOver() {
        let gameOverLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameOverLabel.fontSize = 36
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: self.scene.size.width / 2, y: self.scene.size.height / 2)
        gameOverLabel.text = "Game Over"
        self.scene.addChild(gameOverLabel)
    }
}
