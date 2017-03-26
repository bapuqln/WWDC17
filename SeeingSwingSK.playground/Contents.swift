//#-hidden-code
import PlaygroundSupport
import SpriteKit

public class SwingView : SKScene {
    var selectedNode:SKNode? = nil
    var selectedPhysicsBody:SKPhysicsBody? = nil
    
    var swingBaseNode:SKSpriteNode = SKSpriteNode(color: #colorLiteral(red: 0.968627452850342, green: 0.780392169952393, blue: 0.345098048448563, alpha: 1.0), size: CGSize(width: 0, height: 0))
    var swingHeightNode:SKLabelNode = SKLabelNode(text: nil)
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
    }
    
func pushSwing() {
//#-end-hidden-code
/*:
# An (un)sightly swing!
Below you can configure the amount of force the swing is pushed with. Try using positive a negative force amounts and note what they do.
*/
//#-editable-code
let swingForceOnX = <#T##push force##Double#>
//#-end-editable-code
let forceVector = CGVector(dx: swingForceOnX , dy: 0)
//Give our seat a little boost! 🚀
swingBaseNode.physicsBody?.applyImpulse(forceVector)
    //#-hidden-code
        let startHeightOffset = swingBaseNode.position.y
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {

            var highestSwingPosition:CGFloat = 0;
            while true {
                
                let currentReading = self.swingBaseNode.position.y - startHeightOffset
                self.swingHeightNode.text = "\(Double(Int(currentReading * 100)) / 100.0) units high"
                if (currentReading > highestSwingPosition) {
                    highestSwingPosition = currentReading
                }
                Thread.sleep(forTimeInterval: 0.05)
            }
        }
    }
    //#-end-hidden-code
}
/*:
 ***But wait!*** This demo is entirely inaccessible to those who can't see the output. You don't have to worry about that here but consider the important aspects of a swing push that would be necessary for a person to understand what's going on without needing to see it.
 
 When you are ready to open this demo up to everyone, [continue to the next page](@next)
 */

//#-hidden-code

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

