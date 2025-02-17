import SpriteKit

/// 泡泡放大结束状态，处理泡泡停止放大后的效果
class BubbleScalingEndState: BubbleState {
    func enterState(bubble: StateBubble) {
        // 停止之前的放大动作
        bubble.removeAction(forKey: "scaling")
        
        // 获取泡泡当前的缩放比例和位置
        let currentScale = bubble.xScale
        let currentPosition = bubble.position
        
        // 创建特效精灵节点来播放动画
        let effectNode = createEffectNode(withScale: currentScale)
        // 将特效节点添加到泡泡上
        bubble.addChild(effectNode)
        
        // 播放特效动画
        let endAnimation = createEndAnimation()
        effectNode.run(SKAction.sequence([
            endAnimation,
            SKAction.removeFromParent() // 动画播完后移除特效节点
        ]))
        
        // 播放弹性缩放动画
        bubble.run(createScaleSequence())
        
        // 播放结束音效
        let soundAction = SKAction.playSoundFileNamed("bubbule_blowing_end.mp3", waitForCompletion: false)
        bubble.run(soundAction)
        
        // 等待动画播放完成后切换到正常状态并创建ActiveBubble
        let waitAction = SKAction.wait(forDuration: 0.6) // 等待动画和音效播放完成
        let createActiveBubbleAction = SKAction.run { [weak bubble] in
            if let bubble = bubble {
                // 直接在泡泡上添加 ActiveBubble
                bubble.addActiveBubble()
                
                bubble.addRedCircle()
                
                // 切换泡泡到正常状态
                //bubble.changeState(to: BubbleNormalState())
            }
        }
        
        bubble.run(SKAction.sequence([waitAction, createActiveBubbleAction]))
    }
    
    func exitState(bubble: StateBubble) {
        // 退出结束状态的清理工作
        // 目前不需要特殊处理
    }
    
    func update(bubble: StateBubble) {
        // 结束状态的持续性逻辑
        // 目前不需要特殊处理
    }
    
    /// 创建特效节点
    /// - Parameter scale: 特效节点的缩放比例
    /// - Returns: 配置好的特效精灵节点
    private func createEffectNode(withScale scale: CGFloat) -> SKSpriteNode {
        // 使用第一帧创建特效节点
        let texture = SKTexture(imageNamed: "sc000")
        let effectNode = SKSpriteNode(texture: texture)
        
        // 设置特效节点的尺寸与泡泡一致（默认尺寸是50x50）
        effectNode.size = CGSize(width: 50, height: 50)
        effectNode.setScale(scale) // 使用泡泡当前的缩放比例
        
        // 将特效节点居中显示
        effectNode.position = .zero
        effectNode.zPosition = 1   // 确保显示在泡泡上层
        
        return effectNode
    }
    
    /// 创建放大结束时的帧动画
    /// - Returns: 包含所有结束帧的动画动作
    private func createEndAnimation() -> SKAction {
        var endTextures: [SKTexture] = []
        
        // 加载结束动画的所有帧
        for i in 0...5 { // sc000 到 sc005，共6帧
            let textureName = String(format: "sc%03d", i)
            endTextures.append(SKTexture(imageNamed: textureName))
        }
        
        // 创建动画，每帧显示0.1秒
        return SKAction.animate(with: endTextures, timePerFrame: 0.1)
    }
    
    /// 创建弹性缩放序列
    /// - Returns: 缩放动画序列
    private func createScaleSequence() -> SKAction {
        // 添加一个小的"弹性"动画效果，让停止更自然
        let finalizeScale = SKAction.scale(by: 1.05, duration: 0.1) // 稍微再放大一点
        let scaleBack = SKAction.scale(by: 0.95, duration: 0.1)    // 然后缩小回来
        return SKAction.sequence([finalizeScale, scaleBack])
    }
} 
