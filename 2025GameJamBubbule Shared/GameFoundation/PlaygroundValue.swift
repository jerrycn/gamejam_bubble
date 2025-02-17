//
//  PlaygroundValue.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/21.
//

import Foundation
import UIKit

enum PlaygroundValue {
    case boolean(Bool)
    case integer(Int)
    case floatingPoint(Double)
    case string(String)
    case array([PlaygroundValue])
    case dictionary([String: PlaygroundValue])
    case data(Data)
//    case color(UIColor)
//    case image(UIImage)
//    case data(Data)
//    case none

    // 可以添加自定义方法来方便提取数据
    func extract<T>() -> T? {
        switch self {
        case .boolean(let value): return value as? T
        case .integer(let value): return value as? T
        case .floatingPoint(let value): return value as? T
        case .string(let value): return value as? T
        case .array(let value): return value as? T
        case .dictionary(let value): return value as? T
//        case .color(let value): return value as? T
//        case .image(let value): return value as? T
        case .data(let value): return value as? T
//        case .none: return nil
        }
    }
}
