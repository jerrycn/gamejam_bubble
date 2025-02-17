import SwiftUI
import SpriteKit

protocol CollisionHandler {
    func handleCollision(with node: SKNode, at point: CGPoint)
}

public class BaseSprite: SKSpriteNode {
    
    // 初始化方法
    init(size: CGSize, color: SKColor) {
        super.init(texture: nil, color: color, size: size)
    }
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 设置物理属性
    func setupPhysics() {
        // 设置物理体
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true // 使得物体响应物理引擎
        self.physicsBody?.categoryBitMask = PhysicsCategory.None // 默认类别
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None // 默认无触发碰撞
        self.physicsBody?.collisionBitMask = PhysicsCategory.None // 默认无碰撞反应
        self.physicsBody?.affectedByGravity = true // 是否受重力影响
    }
    
    // 设置物理体的类别
    func setCategoryBitMask(_ category: UInt32) {
        self.physicsBody?.categoryBitMask = category
    }
    
    // 设置物理体的接触检测
    func setContactTestBitMask(_ category: UInt32) {
        self.physicsBody?.contactTestBitMask = category
    }
    
    // 设置物理体的碰撞反应
    func setCollisionBitMask(_ category: UInt32) {
        self.physicsBody?.collisionBitMask = category
    }
    
    // 处理碰撞检测时触发的方法（可由子类重写）
    func didBeginContact(_ contact: BaseSprite?) {
        // 在这里处理碰撞的逻辑
    }
    
     var onCollisionHandler: ((BaseSprite) -> Void)?
    
    /// Sets the function that's called when the sprite collides with another sprite.
    /// - parameter handler: The function to be called when a collision occurs.
    ///
    /// - localizationKey: Sprite.setOnCollisionHandler(_:)
    public func setOnCollisionHandler(_ handler: @escaping ((BaseSprite) -> Void)) {
        onCollisionHandler = handler
    }
    
    // 更新（可由子类重写）
    func update() {
        // 在这里进行自定义的更新操作
    }
    
    
    func touch(touch:Touch){
        
    }
    
    //按下
    func touchBegan(location:CGPoint){
    
    }
    
    //移动
    func touchMove(location:CGPoint){

    }
    
    //抬起
    func touchEnded(location:CGPoint){
        
    }
    
    func update(_ currentTime: TimeInterval) {
            
    }
    
    // 放大功能
    func scaleUp(to scale: CGFloat, duration: TimeInterval) {
        // 先放大视觉效果
        let scaleAction = SKAction.scale(to: scale, duration: duration)
        self.run(scaleAction)
        
    }
    
    /// 处理碰撞的默认实现
    func handleCollision(with node: BaseSprite, at point: CGPoint) {
        // 默认不做任何处理
    }
}
