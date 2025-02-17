import SwiftUI

import SpriteKit

public class Background: BaseSprite {
    
    /// 砖块打裂前可被击中的次数。
    public var strength = 1
    
    override init(size: CGSize, color: UIColor) { 
        let texture = SKTexture(imageNamed: "art-background-5")
        
        super.init(texture: texture, color: color, size: size)
        
        // 确保背景图片填满整个场景
        self.size = size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
