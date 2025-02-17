//
//  PauseNode.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/2/10.
//
import SpriteKit

class PauseNode: SKSpriteNode {
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.black.withAlphaComponent(0.5), size: size)
        self.zPosition = 100 // 确保在最前方
        
        let label = SKLabelNode(text: "游戏暂停")
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: 50)
        addChild(label)

        let resumeButton = SKLabelNode(text: "继续")
        resumeButton.fontSize = 30
        resumeButton.name = "resumeButton"
        resumeButton.position = CGPoint(x: 0, y: -30)
        addChild(resumeButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
