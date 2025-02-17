import SpriteKit

/// 泡泡的爆炸状态，处理泡泡爆炸的动画和效果
class BubbleBurstState: BubbleState {
    func enterState(bubble: StateBubble) {
        // 播放爆炸动画序列
        let burstAnimation = self.createBurstAnimation()
        let removeAction = SKAction.removeFromParent()
        // 播放完动画后移除泡泡
        bubble.run(SKAction.sequence([burstAnimation, removeAction]))
    }
    
    func exitState(bubble: StateBubble) {
        // 爆炸状态的清理工作
        // 通常不会退出爆炸状态，因为泡泡会被移除
    }
    
    func update(bubble: StateBubble) {
        // 爆炸状态的持续性逻辑
        // 目前不需要特殊处理
    }
    
    /// 创建爆炸动画序列
    /// - Returns: 包含所有爆炸帧的动画动作
    private func createBurstAnimation() -> SKAction {
        var burstTextures: [SKTexture] = []
        // 加载爆炸动画的所有帧
        for i in 0...5 { // 6帧爆炸动画
            let textureName = String(format: "bubble_burst_%02d", i)
            burstTextures.append(SKTexture(imageNamed: textureName))
        }
        // 创建动画，每帧显示0.1秒
        return SKAction.animate(with: burstTextures, timePerFrame: 0.1)
    }
} 