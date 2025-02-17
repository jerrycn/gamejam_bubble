//
//  Layout.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/22.
//


import SwiftUI

/// An array of colors used to set up the bricks in a Brick Breaker level.
public struct Layout {
    
    /// The colors of the layout, arranged in an array.
    public var colors: [[Color]] = []
    
    /// The default number of rows in a layout.
    public static var defaultRows = 4
    
    /// The default number of columns in a layout.
    public static var defaultColumns = 4
    
    /// The number of rows in the layout.
    public var rows: Int {
        return colors.count
    }
    
    /// The number of columns in the layout.
    public var columns: Int {
        guard let firstRow = colors.first else { return 0 }
        return firstRow.count
    }
    
    /// A custom layout constructed with color literals.
    /// 使用颜色字面量构成的自定布局。
        public static var custom: Layout {
            let layoutColors: [[Color]] = [
                [#colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0)],
                [#colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0)],
                [#colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.9568627450980393, green: 0.6588235294117647, blue: 0.5450980392156862, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0)],
                [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.9568627450980393, green: 0.6588235294117647, blue: 0.5450980392156862, alpha: 1.0), #colorLiteral(red: 0.9098039215686274, green: 0.47843137254901963, blue: 0.6431372549019608, alpha: 1.0), #colorLiteral(red: 0.9568627450980393, green: 0.6588235294117647, blue: 0.5450980392156862, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)],
                [#colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.9568627450980393, green: 0.6588235294117647, blue: 0.5450980392156862, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0)],
                [#colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0), #colorLiteral(red: 0.5568627450980392, green: 0.35294117647058826, blue: 0.9686274509803922, alpha: 1.0)],
                [#colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0), #colorLiteral(red: 0.9686274509803922, green: 0.7803921568627451, blue: 0.34509803921568627, alpha: 1.0)]
            ]
            return Layout(colors: layoutColors)
        }
    
    /// Creates a layout using an array of colors.
    public init(colors: [[Color]]) {
        self.colors = colors
    }
    
    /// Creates a plain layout of a default color.
    public static func plain(rows: Int = defaultRows, columns: Int = defaultColumns) -> Layout {
        return Layout.color(.cyan, rows: rows, columns: columns)
    }
    
    /// Creates a layout of a specific color.
    public static func color(_ color: Color, rows: Int = defaultRows, columns: Int = defaultColumns) -> Layout {
        let row = Array(repeating: color, count: columns)
        return Layout(colors: Array(repeating: row, count: rows))
    }
    
    /// Creates a layout of random colors.
    public static func random(colors: [Color], rows: Int = defaultRows, columns: Int = defaultColumns) -> Layout {
        var layoutColors: [[Color]] = []
        for _ in 0..<rows {
            var rowColors: [Color] = []
            for _ in 0..<columns {
                rowColors.append(colors.randomElement() ?? .clear)
            }
            layoutColors.append(rowColors)
        }
        return Layout(colors: layoutColors)
    }
}
