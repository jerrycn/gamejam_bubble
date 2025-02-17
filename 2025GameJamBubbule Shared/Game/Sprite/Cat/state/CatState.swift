//
//  PlayerState.swift
//  2025GameJamBubbule
//
//  Created by jerrylong on 2025/1/30.
//


protocol CatState {
    func enterState(cat: Cat)   // 进入状态
    func exitState(cat: Cat)    // 退出状态
    func update(cat: Cat)       // 状态更新（可选）
}
