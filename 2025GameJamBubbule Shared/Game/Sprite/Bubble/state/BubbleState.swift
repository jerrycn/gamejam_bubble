import SpriteKit

/// 泡泡状态机的基础协议，定义了所有泡泡状态必须实现的方法
protocol BubbleState {
    /// 进入该状态时调用
    /// - Parameter bubble: 状态所属的泡泡对象
    func enterState(bubble: StateBubble)
    
    /// 退出该状态时调用
    /// - Parameter bubble: 状态所属的泡泡对象
    func exitState(bubble: StateBubble)
    
    /// 状态更新时调用，用于处理持续性的状态逻辑
    /// - Parameter bubble: 状态所属的泡泡对象
    func update(bubble: StateBubble)
} 