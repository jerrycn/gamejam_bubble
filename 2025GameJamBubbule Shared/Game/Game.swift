import SwiftUI
import SpriteKit

//负责游戏逻辑,胜利,失败,下一关

class Game {
    
    /// 游戏的关卡。
    var levels: [GameLevel] = []
    
    /// 创建游戏并设定其关卡。
    public init(levels: [GameLevel]) {
        self.levels = levels
    }
    
    /// 运行游戏中的一关。
    public func runLevel(index: Int) {
        if index + 1 > levels.count {
            winGame()
        } else {
            levels[index].onCompletion = {
                self.runLevel(index: index + 1)
            }
            nextLevel(number: index + 1)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {_ in
                self.levels[index].run()
            }
        }
    }
    
    /// 运行游戏。
    public func run() {
        runLevel(index: 0)
    }
    
    /// 前往下一关时显示信息。
    func nextLevel(number: Int) {

        let nextLevelMessage = SKLabelNode(fontNamed: "Helvetica")
        nextLevelMessage.fontSize = 120
        nextLevelMessage.fontColor = .white
        nextLevelMessage.position = CGPoint(x: sceneSize.size.width / 2, y: sceneSize.size.height - 150)
        nextLevelMessage.text = "关卡 \(number)"
    
        // 创建淡出动作，持续 3 秒
        let fadeOutAction = SKAction.fadeOut(withDuration: 3.0)
        
        // 创建移除节点的动作
        let removeAction = SKAction.removeFromParent()
        
        // 执行动作序列：先淡出，然后移除
        let sequence = SKAction.sequence([fadeOutAction, removeAction])
        // 执行动作
        nextLevelMessage.run(sequence)
        nextLevelMessage.zPosition = 100000
        //scene.place(nextLevelMessage, at: CGPoint(x: 200, y: 200))
        GameScene.shared?.addChild(nextLevelMessage)

    }
    
    /// 游戏获胜时调用。
    func winGame() {
        //let endMessage = Label(text: "你赢了", color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), font: .MarkerFelt, size: 120)
//        scene.place(endMessage, at: Point(x: 0, y: 275))
        
    }
}
