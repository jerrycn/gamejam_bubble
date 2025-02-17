//
//  Collision.swift
//  
//  Copyright © 2020 Apple Inc. All rights reserved.
//
import SpriteKit
import SwiftUI
//import SPCCore
//import SPCIPC

/// A Collision holds information about when two sprites collide in the scene.
///
/// - localizationKey: Collision
struct Collision: Equatable {

    
    /// One of the sprites in the collision.
    ///
    /// - localizationKey: Collision.spriteA
    public var spriteA: Sprite
    
    /// One of the sprites in the collision.
    ///
    /// - localizationKey: Collision.spriteB
    public var spriteB: Sprite
    
    /// The angle of a collision between two sprites.
    ///
    /// - localizationKey: Collision.angle
    public var angle: Vector
    
    /// The force of a collision between two sprites.
    ///
    /// - localizationKey: Collision.force
    public var force: Double
    
    /// Indicates whether or not the two Sprites in the Collision are 
    public var isOverlapping: Bool
    
    static func ==(lhs: Collision, rhs: Collision) -> Bool {
            return lhs.spriteA == rhs.spriteA &&
                   lhs.spriteB == rhs.spriteB &&
                   lhs.angle == rhs.angle &&
                   lhs.force == rhs.force &&
                   lhs.isOverlapping == rhs.isOverlapping
        }
}


/// A CollisionPair holds references to two sprites in a collision.
///
/// - localizationKey: CollisionPair

struct CollisionPair: Equatable, Hashable {
    
    /// One of the sprites in the collision.
    ///
    /// - localizationKey: CollisionPair.spriteA
    public var spriteA: Sprite
    
    /// One of the sprites in the collision.
    ///
    /// - localizationKey: CollisionPair.spriteB
    public var spriteB: Sprite
    
    static func ==(lhs: CollisionPair, rhs: CollisionPair) -> Bool {
        return lhs.spriteA == rhs.spriteA &&
        lhs.spriteB == rhs.spriteB
    }
    
    // 实现 Hashable 协议的 `hash(into:)` 方法
    func hash(into hasher: inout Hasher) {
        hasher.combine(spriteA.id)
        hasher.combine(spriteB.id)
    }
    
    
}
