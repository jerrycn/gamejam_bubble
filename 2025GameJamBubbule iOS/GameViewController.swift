//
//  GameViewController.swift
//  2025GameJamBubbule iOS
//
//  Created by jerrylong on 2025/1/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载音频设置
        AudioManager.shared.loadSettings()
        
        if let view = self.view as! SKView? {
            // 设置固定场景大小（使用 startgb 图片的尺寸）
            let sceneSize = CGSize(width: 1182, height: 684) // 假设这是 startgb 的尺寸
            
            // 创建开始场景
            let scene = StartScene(size: sceneSize)
            scene.scaleMode = .aspectFit  // 改为 aspectFit 以保持比例
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
