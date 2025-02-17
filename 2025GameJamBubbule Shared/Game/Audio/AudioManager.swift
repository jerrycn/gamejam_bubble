import SpriteKit
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var backgroundMusicNode: SKAudioNode?
    private var isMusicEnabled: Bool = true
    private var isSoundEnabled: Bool = true
    
    // 存储音效节点的数组
    private var soundEffectNodes: [SKAudioNode] = []
    
    // 添加循环音效的支持
    private var loopingSoundNodes: [String: SKAudioNode] = [:]
    
    private init() {}
    
    // MARK: - 背景音乐控制
    
    func setupBackgroundMusic(in scene: SKScene) {
        if let musicNode = backgroundMusicNode {
            musicNode.removeFromParent()
        }
        
        if let musicURL = Bundle.main.url(forResource: "bgm", withExtension: "mp3") {
            backgroundMusicNode = SKAudioNode(url: musicURL)
            if let musicNode = backgroundMusicNode {
                musicNode.autoplayLooped = true
                scene.addChild(musicNode)
                
                // 根据当前状态设置音量
                musicNode.run(SKAction.changeVolume(to: isMusicEnabled ? 1 : 0, duration: 0))
            }
        }
    }
    
    func toggleBackgroundMusic(_ enabled: Bool) {
        isMusicEnabled = enabled
        if let musicNode = backgroundMusicNode {
            let fadeAction = SKAction.changeVolume(
                to: enabled ? 1 : 0,
                duration: 0.5
            )
            musicNode.run(fadeAction)
        }
        
        // 保存设置
        UserDefaults.standard.set(enabled, forKey: "BackgroundMusicEnabled")
    }
    
    // MARK: - 音效控制
    
    func playSoundEffect(name: String, in scene: SKScene) {
        guard isSoundEnabled else { return }
        
        if let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") {
            let soundNode = SKAudioNode(url: soundURL)
            soundNode.autoplayLooped = false
            scene.addChild(soundNode)
            
            // 播放完成后移除节点
            let playAction = SKAction.play()
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([playAction, removeAction])
            soundNode.run(sequence)
            
            // 添加到数组中以便管理
            soundEffectNodes.append(soundNode)
        }
    }
    
    // 播放循环音效
    func playLoopingSoundEffect(name: String, in scene: SKScene) {
        guard isSoundEnabled else { return }
        
        // 如果已经在播放，就不重复播放
        if loopingSoundNodes[name] != nil { return }
        
        if let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") {
            let soundNode = SKAudioNode(url: soundURL)
            soundNode.autoplayLooped = true
            scene.addChild(soundNode)
            
            // 添加淡入效果
            soundNode.run(SKAction.changeVolume(to: 1.0, duration: 0.3))
            
            // 保存引用
            loopingSoundNodes[name] = soundNode
        }
    }
    
    // 停止循环音效
    func stopLoopingSoundEffect(name: String) {
        if let soundNode = loopingSoundNodes[name] {
            // 添加淡出效果
            let fadeOut = SKAction.sequence([
                SKAction.changeVolume(to: 0, duration: 0.3),
                SKAction.removeFromParent()
            ])
            soundNode.run(fadeOut)
            loopingSoundNodes.removeValue(forKey: name)
        }
    }
    
    // 修改音效开关方法
    func toggleSoundEffects(_ enabled: Bool) {
        isSoundEnabled = enabled
        
        if !enabled {
            // 停止所有音效
            soundEffectNodes.forEach { node in
                node.run(SKAction.stop())
            }
            // 停止所有循环音效
            loopingSoundNodes.forEach { (_, node) in
                node.run(SKAction.stop())
            }
            loopingSoundNodes.removeAll()
        }
        
        UserDefaults.standard.set(enabled, forKey: "SoundEffectsEnabled")
    }
    
    // MARK: - 设置加载
    
    func loadSettings() {
        isMusicEnabled = UserDefaults.standard.bool(forKey: "BackgroundMusicEnabled", defaultValue: true)
        isSoundEnabled = UserDefaults.standard.bool(forKey: "SoundEffectsEnabled", defaultValue: true)
    }
}

// 扩展 UserDefaults 以支持默认值
extension UserDefaults {
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if object(forKey: key) == nil {
            set(defaultValue, forKey: key)
            return defaultValue
        }
        return bool(forKey: key)
    }
} 