//
//  IdleState.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/30.
//

import SpriteKit

class CatIdleState: CatState {
    func enterState(cat: Cat) {
        cat.removeAllActions()
        cat.physicsBody?.velocity = CGVector(dx: 1, dy: 1)
        cat.run(SKAction.repeatForever(cat.walkAnimation))
    }
    
    func exitState(cat: Cat) { }
    
    func update(cat: Cat) { }
}
