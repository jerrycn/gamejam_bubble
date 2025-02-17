import SpriteKit

/// 泡泡的放大状态，处理泡泡持续放大的逻辑
class BubbleScalingState: BubbleState {
    func enterState(bubble: StateBubble) {
        // 开始放大动画：每秒放大1.5倍，无限循环
        let scaleAction = SKAction.scale(by: 1.5, duration: 1.0)
        bubble.run(SKAction.repeatForever(scaleAction), withKey: "scaling")
        
        // 标记这个泡泡正在放大
        bubble.name = "scaling_bubble"
        
        // 初始化物理体
        updatePhysicsBody(bubble: bubble)
    }
    
    func exitState(bubble: StateBubble) {
        // 退出放大状态时，移除放大动作
        bubble.removeAction(forKey: "scaling")
        // 恢复泡泡的原始名称
        bubble.name = "stateBubble"
    }
    
    func update(bubble: StateBubble) {
        // 更新物理体大小以匹配当前缩放
        updatePhysicsBody(bubble: bubble)
        
        // 检查猫是否在泡泡范围内
        if let scene = bubble.scene as? GameScene,
           let cat = scene.children.first(where: { $0.name == "cat" }) {
            
            // 计算猫和泡泡的距离
            let distance = hypot(cat.position.x - bubble.position.x,
                               cat.position.y - bubble.position.y)
            
            // 获取泡泡当前的半径（考虑缩放）
            let bubbleRadius = (bubble.size.width / 2) * bubble.xScale
            
            // 如果猫离开泡泡范围，结束放大状态
            if distance > bubbleRadius {
                bubble.endScaling()
            }
        }
    }
    
    // 更新物理体大小
    private func updatePhysicsBody(bubble: StateBubble) {
        // 计算当前实际半径
        let currentRadius = bubble.size.width / 2 * bubble.xScale
        
        // 创建新的物理体
        let newPhysicsBody = SKPhysicsBody(circleOfRadius: currentRadius)
        
        // 设置物理体属性
        newPhysicsBody.isDynamic = true
        newPhysicsBody.affectedByGravity = false
        newPhysicsBody.allowsRotation = true
        newPhysicsBody.linearDamping = 0.5
        newPhysicsBody.angularDamping = 0.1
        newPhysicsBody.restitution = 0.7
        
        // 设置碰撞检测类别
        newPhysicsBody.categoryBitMask = PhysicsCategory.Bubble
        newPhysicsBody.contactTestBitMask = PhysicsCategory.Bubble
        newPhysicsBody.collisionBitMask = PhysicsCategory.None
        
        // 更新泡泡的物理体
        bubble.physicsBody = newPhysicsBody
    }
} 