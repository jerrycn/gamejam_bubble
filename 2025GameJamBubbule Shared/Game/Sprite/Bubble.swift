import SwiftUI
import SpriteKit

public class Bubble: BaseSprite {
    
    // 泡泡的基本初始化
    override init(size: CGSize, color: UIColor) {
        let texture = SKTexture(imageNamed: "paopao")
        super.init(texture: texture, color: color, size: size)
        self.name = "bubble"
        self.position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: UIScreen.main.bounds.height)
        setupPhysics()
        self.setCategoryBitMask(PhysicsCategory.Bubble)
        self.setContactTestBitMask(PhysicsCategory.Player)
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = CGFloat.random(in: 0...0.9)  // 更高的值会让泡泡减速
        self.physicsBody?.angularDamping = 0.1 // 控制旋转的减速
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
   
}
