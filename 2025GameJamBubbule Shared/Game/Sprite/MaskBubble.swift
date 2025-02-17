import SwiftUI
import SpriteKit

public class MaskBubble: BaseSprite {
    
    var maskNode: SKShapeNode!
 
    var scaleSpeed: CGFloat = 0.05  // 每帧放大的比例
    var targetScale: CGFloat = 2.0  // 目标放大比例，最大值
    private var isScaling = false
    
    // 初始化 MaskBubbles，接受精灵图像、背景图像和遮罩类型
    init(size: CGSize, color: UIColor,addbackground : Bool = false) {
        
        let spriteNode = SKSpriteNode(imageNamed: "art-background-1")  // Replace with your image name
        spriteNode.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height / 2)
        
        // Create the mask node (a circular shape)
        maskNode = SKShapeNode(circleOfRadius: size.width * 0.5)
        maskNode.setScale(1.0)
        maskNode.fillColor = .white
        maskNode.position = CGPoint(x: 100, y: sceneSize.height / 2)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 0)
        cropNode.addChild(spriteNode)
        cropNode.maskNode = maskNode
        
        // Add the crop node to the scene
        //gameScene.addChild(cropNode)
        GameScene.shared?.addChild(cropNode)
        
        let texture = SKTexture(imageNamed: "art-bubble")
        super.init(texture: texture, color: color, size: size)
        self.name = "MaskBubbles"
        self.position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: UIScreen.main.bounds.height)
        setupPhysics()
        self.setCategoryBitMask(PhysicsCategory.MaskBubbles)
        self.setContactTestBitMask(PhysicsCategory.MaskBubbles)
        self.setCollisionBitMask(PhysicsCategory.MaskBubbles)
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = CGFloat.random(in: 0...0.9)  // 更高的值会让泡泡减速
        self.physicsBody?.angularDamping = 0.1 // 控制旋转的减速
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setPosition(pos:CGPoint){
        self.position = pos 
        self.maskNode.position = pos
    }
    
    // 放大功能
    override func scaleUp(to scale: CGFloat, duration: TimeInterval) {
        // 先放大视觉效果
        let scaleAction = SKAction.scale(to: scale, duration: duration)
        self.run(scaleAction)
        
        //let scaleAction = SKAction.scale(to: scale, duration: duration)
        maskNode.run(scaleAction)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if isScaling {
            if self.xScale < targetScale {
                let newScale = self.xScale + scaleSpeed
                self.setScale(min(newScale, targetScale))
            }
        }
    }
    
    func startScaling() {
        isScaling = true
        self.setScale(0.1) // 从小尺寸开始
    }
    
    // 处理碰撞检测时触发的方法（可由子类重写）
    override func didBeginContact(_ contact: BaseSprite?) {
        isScaling = false
    }
    
}
