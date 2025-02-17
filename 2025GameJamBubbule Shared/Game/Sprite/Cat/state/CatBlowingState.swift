//
//  CatBlowingState.swift
//  2025GameJamBubbule
//  吹气状态
//  Created by jerrylong on 2025/1/30.
//

import SpriteKit


class CatBlowingState: CatState {
    
    init() {
      
    }
    
    func enterState(cat: Cat) {
        cat.removeAllActions()
        cat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        cat.run(SKAction.repeatForever(cat.blowAnimation))
        // 开始播放吹泡泡音效
        cat.startBlowingSound()
    }
    
    func exitState(cat: Cat) {
        cat.removeAllActions()
        // 停止播放吹泡泡音效
        cat.stopBlowingSound()
    }
    
    func update(cat: Cat) {
        // 可在这里处理动态加速
    }
}

