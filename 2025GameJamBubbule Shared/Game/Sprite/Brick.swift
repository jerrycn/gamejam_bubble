import SwiftUI
import SpriteKit

public class Brick: BaseSprite {
    
    /// 砖块打裂前可被击中的次数。
    public var strength = 1
    
    override init(size: CGSize, color: UIColor) { 
        let texture = SKTexture(imageNamed: "Brick")
        
        super.init(texture: texture, color: color, size: size)
        
        self.name = "brick"
        
        self.setupPhysics()
        self.setCategoryBitMask(PhysicsCategory.Brick)
        self.setContactTestBitMask(PhysicsCategory.Player)
        // 碰撞后不能穿过玩家或泡泡
        self.setCollisionBitMask(PhysicsCategory.Player | PhysicsCategory.Bubble)
        
        self.onCollisionHandler = { collision in 
            //scene.gameUI.updateLog("-----onCollisionHandler")
            self.applyDirectionForce()
        }
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDirectionForce() {
        // 假设我们想要让泡泡朝右上方移动
        let direction = CGVector(dx: 2, dy: 100) // 向右上方施加一个力
        self.physicsBody?.applyForce(direction)
    }
    
}
