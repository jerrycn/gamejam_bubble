//
//  ActiveBubble.swift
//  2025GameJamBubbule
//  激活泡泡
//  Created by jerrylong on 2025/1/25.
//

import SpriteKit

class ActiveBubble: BaseSprite {
    
    static let texture : SKTexture! = SKTexture(imageNamed: "art-background-1")
    
    override init(texture: SKTexture? = nil, color: SKColor, size: CGSize) {
        let texture = SKTexture(imageNamed: "art-background-1")
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func createCircularSprite(center: CGPoint, radius: CGFloat) -> SKNode {
        //计算屏幕与纹理的比例
        let scaledWidth =  texture.size().width / sceneSize.width
        let scaledHeight = texture.size().height / sceneSize.height
        
        // 计算裁剪矩形的比例（相对值）
        let cropRect = CGRect(
            x: (center.x - radius) / texture.size().width * scaledWidth,
            y: (center.y - radius) / texture.size().height * scaledHeight,
            width: (2 * radius) / texture.size().width * scaledWidth,
            height: (2 * radius) / texture.size().height * scaledHeight
        )
        
        // 从纹理中裁剪子纹理
        let croppedTexture = SKTexture(rect: cropRect, in: texture)
        
        
        // 创建精灵
        let sprite = SKSpriteNode(texture: croppedTexture)
        sprite.size = CGSize(width: 2 * radius, height: 2 * radius)
        // 设置锚点为中心点
//        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // 创建圆形遮罩节点
        let maskNode = SKShapeNode(circleOfRadius: radius)
        maskNode.fillColor = .white  // 遮罩必须是完全白色
        maskNode.strokeColor = .red
        
        // 创建裁剪节点并设置遮罩
        let cropNode = SKCropNode()
        cropNode.maskNode = maskNode
        cropNode.addChild(sprite)
       
        return cropNode
    }
    
}
