import PlaygroundSupport
import SpriteKit


public class WelcomeScene: SKScene {
    var selectedNode:SKNode? = nil
    var selectedPhysicsBody:SKPhysicsBody? = nil
    
    var sunNode:SKSpriteNode? = nil
    var helperText:SKLabelNode? = nil
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let positionInScene = touch?.location(in: self) else {return}
        
        if let touchedNode = self.nodes(at: positionInScene).first {
            if (touchedNode.name == "moon") {
                selectedNode = touchedNode
                //We have a touched object, we should animate
                selectedPhysicsBody = touchedNode.physicsBody
                touchedNode.physicsBody = nil
            }else if (touchedNode.name == "positionDebugger") {
                selectedNode = touchedNode
                //We have a touched object, we should animate
                selectedPhysicsBody = touchedNode.physicsBody
                touchedNode.physicsBody = nil
            }
        }
        
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchDelta = CGPoint(x: touch.location(in: self).x - touch.previousLocation(in: self).x, y: touch.location(in: self).y - touch.previousLocation(in: self).y)
        if let selected = selectedNode {
            if (selected.name == "moon") {
                print("X: \(selected.position.x) y: \(selected.position.y)")
                selected.position.x += touchDelta.x
                selected.position.y = getMoonY(forX: touch.location(in: self).x)
                sunNode!.position.x = selected.position.x+500 //If we trace behind 500 we come up at the right time
                sunNode!.position.y = getMoonY(forX: selected.position.x+500) //again^^
                
                if (Int(selected.position.x) % 4 == 0) {
                    //self.backgroundColor = getColorBackground(forX: selected.position.x)
                    self.run(SKAction.colorize(with: getColorBackground(forX: selected.position.x), colorBlendFactor: 1.0, duration: 0.1))
                }
                
                //Don't overlap the text, if we will, fade out
                if (selected.position.y+(selected.frame.size.width/2) >= helperText!.position.y) {
                    helperText?.run(SKAction.fadeOut(withDuration: 0.1))
                }
                
                if (selected.position.y <= selected.frame.size.width * 0.5 && selected.position.x <= self.frame.width/2) {
                    //Moon has disapeared!
                    //Disable moon interaction since we are taking over.
                    selected.name = "moon tracking disabled"
                    helperText?.run(SKAction.fadeOut(withDuration: 0.1))
                    //Begin our track
                    let moonTrack = SKAction.customAction(withDuration: 10.5, actionBlock: {
                        [unowned self, sunNode]
                        node, time in
                        if (node.position.x > -150 ) {
                        node.position.y = self.getMoonY(forX: node.position.x - 6)
                        node.position.x -= 6
                        
                        sunNode!.position.x = node.position.x+500 //If we trace behind 500 we come up at the right time
                        sunNode!.position.y = self.getMoonY(forX: node.position.x+500) //again^^
                        }
                    })
                    
                    selected.run(moonTrack)
                }
            }else if (selected.name == "positionDebugger") {
                selected.position.x += touchDelta.x
                selected.position.y += touchDelta.y
                print("X: \(selected.position.x) y: \(selected.position.y)")
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedNode != nil {
            //selectedNode?.removeAction(forKey: "shake")
            selectedNode!.physicsBody = selectedPhysicsBody
            selectedPhysicsBody = nil
            selectedNode = nil
        }
    }
    
    
    /// Called to prepare the scene with everything it needs to be actually useful. MUST BE CALLED!
    public func prepareScene() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.speed = 0.9999
        self.backgroundColor = UIColor.black
        addProps()
    }
    
    
    /// Add all our objects and get them setup
    public func addProps() {
        let moon = SKSpriteNode(texture: SKTexture(imageNamed: "Moon.png"))
        moon.name = "moon"
        moon.size = CGSize(width: 150, height: 150)
        moon.position = CGPoint(x: self.size.width * 0.75, y: getMoonY(forX: self.size.width * 0.75))
        moon.physicsBody?.isDynamic = false
        self.addChild(moon)
        
        helperText = SKLabelNode(text: "Wake the world up")
        helperText!.fontSize = 65
        helperText!.color = .white
        helperText!.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.75)
        
        self.addChild(helperText!)
        
        sunNode = SKSpriteNode(texture: SKTexture(imageNamed: "Sun.png"))
        sunNode!.name = "sun"
        sunNode!.size = CGSize(width: 250, height: 250)
        sunNode!.position = CGPoint(x: self.size.width, y: -250)
        sunNode!.physicsBody?.isDynamic = false
        self.addChild(sunNode!)
        
        let positionDebugger = SKSpriteNode(color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), size: CGSize(width: 25, height: 25))
        positionDebugger.name = "positionDebugger"
        self.addChild(positionDebugger)
        
        positionDebugger.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.5)


    }
    
    func getMoonY(forX:CGFloat) -> CGFloat {
        //Break up our quadratic into bits because the compiler can't handle a simple quadratic???
        let a:CGFloat = -(1/250)
        let interceptOne = (forX-self.frame.width+100)
        let interceptTwo = (forX-100)
        return a * interceptOne * interceptTwo
        
        
    }
    
    func getColorBackground(forX:CGFloat) ->UIColor {
        let startCoord = 566.0
        let endCoord = 0.0
        let stepSize = 1.0 / (startCoord-endCoord)
        let xPosition = startCoord - Double(forX)
        //let color = colorSequence!.sample(atTime: forX)
        return UIColor.init(colorLiteralRed: Float((69*stepSize*xPosition)/255.0), green: Float((193*stepSize*xPosition)/255.0), blue: Float((244*stepSize*xPosition)/255.0), alpha: 1)
    }
    
}

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 1024, height: 768))

let scene = WelcomeScene(size: sceneView.frame.size)
scene.prepareScene()
sceneView.showsFPS = true
sceneView.presentScene(scene)
scene.backgroundColor
PlaygroundPage.current.needsIndefiniteExecution = true

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

