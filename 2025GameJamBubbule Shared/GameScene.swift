//
//  GameScene.swift
//  2025GameJamBubbule Shared
//
//  Created by jerrylong on 2025/1/21.
//

import SpriteKit

var sceneSize : CGSize = CGSize.zero
var sceneCenterPoint : CGPoint = CGPoint.zero

class GameScene: SKScene {
    // Static Singleton instance
    static var shared: GameScene?
    
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    var pauseNode: PauseNode?
    internal var graphicsPlacedDuringCurrentInteraction = Set<Graphic>()
    
    /// A dictionary of the graphics that have been placed on the Scene, using each graphic’s id property as keys.
    ///
    /// - localizationKey: Scene.placedGraphics
    public var placedGraphics = [String: Graphic]()
    
    /// - localizationKey: Scene.onTouchMovedHandler
    public var onTouchMovedHandler: ((Touch) -> Void)?
    
    internal var lastPlacePosition: Point = Point(x: Double.greatestFiniteMagnitude, y: Double.greatestFiniteMagnitude)
    
    class func newGameScene() -> GameScene {
        // Check if the shared instance already exists
        if let existingScene = GameScene.shared {
            return existingScene
        }
        
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        sceneSize = scene.size
        sceneCenterPoint = CGPoint(x: sceneSize.width*0.5 , y: scene.size.height*0.5)
        // Save the instance to the shared property
        GameScene.shared = scene
        return scene
    }
    
    func setUpScene() {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            //label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 4.0
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    override func didMove(to view: SKView) {
        self.commonInit()
        
        self.setUpScene()
        
        self.main()
    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.zPosition = 10000
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }
    
    
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    func touchesBeganback(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        /*
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }*/
        
//        for t in touches {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
//        }
        
        let skTouchPosition = touches[touches.startIndex].location(in: self)
        
        let doubleTouch = touches.first?.tapCount == 2
        
        handleTouch(at: skTouchPosition, firstTouch: true, doubleTouch: doubleTouch)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
//        }
        
        super.touchesMoved(touches, with: event)
        
        let skTouchPosition = touches[touches.startIndex].location(in: self)
        handleTouch(at: skTouchPosition)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
//        }
        
        let skTouchPosition = touches[touches.startIndex].location(in: self)
        handleTouch(at: skTouchPosition, lastTouch: true)
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
        
        let skTouchPosition = touches[touches.startIndex].location(in: self)
        handleTouch(at: skTouchPosition, lastTouch: true)
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

