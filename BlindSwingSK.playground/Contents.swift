//#-hidden-code
import PlaygroundSupport
import SpriteKit
import AVFoundation

public class SwingView : SKScene {
    var selectedNode:SKNode? = nil
    var selectedPhysicsBody:SKPhysicsBody? = nil
    
    var swingBaseNode:SKSpriteNode = SKSpriteNode(color: #colorLiteral(red: 0.968627452850342, green: 0.780392169952393, blue: 0.345098048448563, alpha: 1.0), size: CGSize(width: 0, height: 0))
    var swingHeightNode:SKLabelNode = SKLabelNode(text: nil)
    
    var speechSynth:AVSpeechSynthesizer? = AVSpeechSynthesizer();
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let positionInScene = touch?.location(in: self) else {return}
        
        if let touchedNode = self.nodes(at: positionInScene).first {
            selectedPhysicsBody = touchedNode.physicsBody
            selectedNode = touchedNode
            
            //touchedNode.physicsBody = nil
        }
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchDelta = CGPoint(x: touch.location(in: self).x - touch.previousLocation(in: self).x, y: touch.location(in: self).y - touch.previousLocation(in: self).y)
        if let selected = selectedNode {
            selected.position.x += touchDelta.x
            selected.position.y += touchDelta.y
        }
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedNode != nil {
            //selectedNode?.removeAction(forKey: "shake")
            //selectedNode!.physicsBody = selectedPhysicsBody
            //selectedPhysicsBody = nil
            selectedNode = nil
        }
    }
    
    
    public func prepare() {
        self.backgroundColor = #colorLiteral(red: 0.258823543787003, green: 0.756862759590149, blue: 0.968627452850342, alpha: 1.0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        let CENTER_X = self.frame.width/2
        //create our swing
        let swingArm = SKSpriteNode(color: #colorLiteral(red: 0.505882382392883, green: 0.337254911661148, blue: 0.0666666701436043, alpha: 1.0), size: CGSize(width: 20, height: 450))
        swingArm.position = CGPoint(x: CENTER_X, y: self.frame.height - swingArm.size.height/2 - 0)
        swingArm.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 300))
        self.addChild(swingArm)
        
        let swingBase = SKSpriteNode(color: #colorLiteral(red: 0.925490200519562, green: 0.235294118523598, blue: 0.10196078568697, alpha: 1.0), size: CGSize(width: 200, height: 20))
        swingBase.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 20))
        swingBase.position = CGPoint(x: CENTER_X, y: swingArm.position.y - swingArm.size.height/2)
        self.addChild(swingBase)
        swingBaseNode = swingBase
        
        swingHeightNode = SKLabelNode(text: "Ready... set.. swing!")
        swingHeightNode.position = CGPoint(x: swingBase.position.x, y: swingBase.position.y - 75)
        swingHeightNode.color = #colorLiteral(red: 0.0901960805058479, green: 0.133333340287209, blue: 0.0392156876623631, alpha: 1.0)
        swingHeightNode.fontName = "helvetica"
        self.addChild(swingHeightNode)
        
        
        let ceiling = SKSpriteNode(color: #colorLiteral(red: 0.466666668653488, green: 0.764705896377563, blue: 0.266666680574417, alpha: 1.0), size: CGSize(width: self.frame.width, height: 5))
        ceiling.position = CGPoint(x: self.frame.width/2, y: self.frame.height)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 5))
        ceiling.physicsBody?.isDynamic = false
        self.addChild(ceiling)
        
        let pinJoint = SKPhysicsJointFixed.joint(withBodyA: swingBase.physicsBody!, bodyB: swingArm.physicsBody!, anchor: swingBase.position)
        self.physicsWorld.add(pinJoint)
        
        let swingJoint = SKPhysicsJointPin.joint(withBodyA: ceiling.physicsBody!, bodyB: swingArm.physicsBody!, anchor: ceiling.position)
        self.physicsWorld.add(swingJoint)
        speak(message: "Ready to simulate")
    }
    func speak(message:String) {
        print(message)
        speechSynth?.stopSpeaking(at: AVSpeechBoundary.immediate);
        let utterance = AVSpeechUtterance(string: message)
        utterance.rate = 0.6
        speechSynth?.speak(utterance)
    }
    func pushSwing() {
        let startHeightOffset = swingBaseNode.position.y
        //#-end-hidden-code
/*:
# Making a swing for everyone
Adding accessibility support may seem like a daunting task or simply not worth the time however it's not as hard to implement as it looks!
         
You'll need sound here so you can hear your VoiceOver. Be sure to keep your messages quick and concise. Everything is happening very fast and you don’t want to get jumbled messages!
         
Done? [Continue to conclusion](@next)
*/
//#-code-completion(everything, hide)
//#-editable-code
let swingForceOnX = <#T##push force##Double#>
//#-end-editable-code
let forceVector = CGVector(dx: swingForceOnX , dy: 0)
//Give our seat a little boost! 🚀
swingBaseNode.physicsBody?.applyImpulse(forceVector)
//Give the user a good description about what is about to happen (i.e.: "push!")
//#-editable-code
speak(message: <#T##spoken String##String#>)
//#-end-editable-code
//#-hidden-code

        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            var highestSwingPosition:CGFloat = 0;
            
            for i in 1 ... 50 {
                let currentReading = self.swingBaseNode.position.y - startHeightOffset
                if (i == 5) {
                    self.speak(didSwingRight: self.swingBaseNode.position.x >= self.frame.width/2)
                }
                self.swingHeightNode.text = "\(Double(Int(currentReading * 100)) / 100.0) units high"
                if (currentReading > highestSwingPosition) {
                    highestSwingPosition = currentReading
                }
                
                Thread.sleep(forTimeInterval: 0.05)
            }
            self.speak(swingHighestPoint:  Double(Int(highestSwingPosition * 100)) / 100.0)
        }
    }
    //#-end-hidden-code
    
    
/// Tell the user what direction the swing has swung. It's hard to know what direction positive and negative forces pushed the swing if we don't tell them!
///
/// - Parameter didSwingRight: A boolean that is true when the swing was initially pushed to the right
func speak(didSwingRight:Bool) {
//#-code-completion(everything, hide)
if (didSwingRight) {
    //Tell the user that the swing went to the right
    //#-editable-code
    speak(message: <#T##spoken String##String#>)
    //#-end-editable-code
}else {
    //Tell the user that the swing went to the left this time instead
    //#-editable-code
    speak(message: <#T##spoken String##String#>)
    //#-end-editable-code
  }
}
    
    
/// It's also important to know how high the swing went. Tell the user how high their force pushed the swing!
///
/// - Parameter highestPoint: a double (i.e. 102.22) describing the highest point the swing reached in some unit
func speak(swingHighestPoint:Double) {
    //#-code-completion(everything, hide)
    //#-code-completion(identifier, show, swingHighestPoint)
    //Tell the user how high the seat went. You will need to concatenate highestPoint (a double!) into your message!
    //#-editable-code
    speak(message: <#T##spoken String##String#>)
    //#-end-editable-code
}
//#-hidden-code
    
    
}
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 864, height: 1248))
let scene = SwingView(size: sceneView.frame.size)
scene.prepare()
sceneView.showsFPS = true
sceneView.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

let dispathTime = DispatchTime.now() + 2
DispatchQueue.main.asyncAfter(deadline: dispathTime, execute: {
    scene.pushSwing()
})
//#-end-hidden-code

