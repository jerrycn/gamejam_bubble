//
//  CGPoint+ext.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/22.
//

import UIKit

extension CGPoint {
    init(from point: Point) {
        self.init(x: point.x, y: point.y)
    }
}
