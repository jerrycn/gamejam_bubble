import SpriteKit

/// Enemy 状态基类
class EnemyState {
    /// 进入状态时调用
    func enterState(enemy: Enemy) {}
    
    /// 退出状态时调用
    func exitState(enemy: Enemy) {}
    
    /// 状态更新时调用
    func update(enemy: Enemy) {}
} 