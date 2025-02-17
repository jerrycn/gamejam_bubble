import SwiftUI

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0x1 << 0   //Player的物理类别  
    static let Bubble: UInt32 = 0x1 << 1   //Bubble的物理类别 
    static let Enemy: UInt32 = 0x1 << 2     //增加墙壁的物理类别
    static let Brick: UInt32 = 0x1 << 3    //增加砖块的物理类别
    static let MaskBubbles: UInt32 = 0x1 << 4    //增加砖块的物理类别
}
