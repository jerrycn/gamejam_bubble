//
//  Graphic+ext.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/23.
//

import SpriteKit

extension Graphic : Equatable, Hashable {
    static func == (lhs: Graphic, rhs: Graphic) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
