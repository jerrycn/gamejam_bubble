import SpriteKit

/// 泡泡的正常状态，处理泡泡的基础物理行为
class BubbleNormalState: BubbleState {
    func enterState(bubble: StateBubble) {
        // 设置泡泡的基础物理属性
        bubble.physicsBody?.isDynamic = true      // 启用物理模拟
        bubble.physicsBody?.linearDamping = 0.5   // 设置线性阻尼，让移动更平滑
        bubble.physicsBody?.angularDamping = 0.1  // 设置角速度阻尼，控制旋转
    }
    
    func exitState(bubble: StateBubble) {
        // 退出正常状态时的清理工作
        // 目前不需要特殊处理
    }
    
    func update(bubble: StateBubble) {
        // 正常状态下的持续性逻辑
        // 可以在这里添加漂浮效果等
    }
} 
