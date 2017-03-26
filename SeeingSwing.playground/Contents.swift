import SceneKit
import PlaygroundSupport

public class SeeingSwing:SCNView{
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let quaternion = self.pointOfView!.orientation
        let position = self.pointOfView!.position
        print("Orientation: (\(quaternion.x),\(quaternion.y),\(quaternion.z),\(quaternion.w)) Position: (\(position.x),\(position.y),\(position.z)")
    }
    public func prepare() {
        self.autoenablesDefaultLighting = true
        self.scene = SCNScene()
        self.allowsCameraControl = true
        setupProps()
        
        let camera = SCNCamera()
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(-2, 1.33, 3.64709)
        cameraNode.orientation = SCNQuaternion(x: -0.0873, y: -0.2751, z: 0.01127, w: 0.9574)
        
        self.scene!.rootNode.addChildNode(cameraNode)
        
        self.pointOfView = cameraNode
    }
    
    func setupProps() {
        
        let swingBase = SCNBox(width: 2, height: 0.5, length: 4, chamferRadius: 0.1)
        swingBase.firstMaterial?.diffuse.contents = UIColor.red
        let swingBaseNode = SCNNode(geometry: swingBase)
        swingBaseNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape.init(geometry: swingBase, options: nil))
        
        let swingArm1 = SCNBox(width: 0.1, height: 4, length: 0.1, chamferRadius: 0)
        swingArm1.firstMaterial?.diffuse.contents = UIColor.green
        let swingArm1Node = SCNNode(geometry: swingArm1)
        swingArm1Node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape.init(geometry: swingArm1, options: nil))
        
        let ceiling = SCNBox(width: 10, height: 0.1, length: 10, chamferRadius: 0.0)
        ceiling.firstMaterial?.diffuse.contents = UIColor.blue
        
        let ceilingNode = SCNNode(geometry: ceiling)
        ceilingNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape.init(geometry: ceiling, options: nil))
        ceilingNode.position = SCNVector3(0.0, 10, 0)
        
        let anchor1 = SCNPhysicsBallSocketJoint(bodyA: swingArm1Node.physicsBody!, anchorA: SCNVector3(0, 3, 0), bodyB: ceilingNode.physicsBody!, anchorB: SCNVector3(0, 0, 0))
        self.scene!.physicsWorld.addBehavior(anchor1)
        
        self.scene!.physicsWorld.addBehavior()
        
        
        //self.scene!.rootNode.addChildNode(swingBaseNode)
        self.scene!.rootNode.addChildNode(ceilingNode)
        self.scene!.rootNode.addChildNode(swingArm1Node)
    }
    
}
let view = SeeingSwing()
view.prepare()

PlaygroundPage.current.liveView = view


