import SwiftUI

import SpriteKit

// 定义 Player 的状态
enum PlayerState {
    case moving
    case paused
}

public class Player: BaseSprite {
    // 当前状态
    private var currentState: PlayerState = .paused
    
    // 状态回调闭包
    var stateChangedCallback: ((PlayerState) -> Void)?
    
    // 初始化方法，传入圆形半径和颜色
    override init(size: CGSize, color: UIColor) { 
        let texture = SKTexture(imageNamed: "cat_walk00_00")
        
        super.init(texture: texture, color: color, size: size)
        
        self.name = "player"
//        self.path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2), transform: nil)
//        self.fillColor = color
//        self.strokeColor = .clear
        
        self.setupPhysics()
        self.setCategoryBitMask(PhysicsCategory.Player)
        self.setContactTestBitMask(PhysicsCategory.Bubble | PhysicsCategory.Brick)
        self.setCollisionBitMask(PhysicsCategory.Enemy)
        
        // 加载所有帧的图像
        var walkTextures: [SKTexture] = []
        
        for i in 0...14 {  // 从 cat_walk00_00 到 cat_walk00_14
            let textureName = String(format: "cat_walk00_%02d", i)
            walkTextures.append(SKTexture(imageNamed: textureName))
        }
        
        // 创建动画动作，设置每一帧显示的时间
        let walkAnimation = SKAction.animate(with: walkTextures, timePerFrame: 0.1)
        
        // 让玩家精灵执行动画
        self.run(SKAction.repeatForever(walkAnimation))  
    }
    
    // 设置状态的方法，包含状态变化的回调
    func setState(_ state: PlayerState) {
        stateChangedCallback?(state)
//        let oldState = currentState
//       // if oldState != state {
//            currentState = state
//            // 执行状态变化的回调，传递旧状态和新状态
//            stateChangedCallback?(oldState, currentState)
    //}
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchBegan(location:CGPoint){
        self.position.x = location.x
        self.position.y = location.y
        //self.scaleUp(to: 5.0, duration: 1.0)
        setState(.moving)
        //applyDirectionForce()
//        self.applyImpulseForce()
        
    }
    
    override func touchMove(location:CGPoint){
        self.position.x = location.x
        self.position.y = location.y
        //self.scaleUp(to: 5.0, duration: 1.0)
    }
    
    override func touchEnded(location:CGPoint){
        //self.scaleUp(to: 5.0, duration: 1.0)
        setState(.paused)
    }
    
    // 设置方向力
    func applyDirectionForce() {
        // 假设我们想要让泡泡朝右上方移动
        let direction = CGVector(dx: 2, dy: 100) // 向右上方施加一个力
        self.physicsBody?.applyForce(direction)
    }
    
    // 设置方向力
    func applyImpulseForce() {
        // 增加一个瞬时冲量，使泡泡有一个初始的加速度
        let directionImpulse = CGVector(dx: 5, dy: 5)  // 向右上方的冲量
        self.physicsBody?.applyImpulse(directionImpulse)
    }
    
}
