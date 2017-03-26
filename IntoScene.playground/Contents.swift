import PlaygroundSupport
import SpriteKit


//
//  WelcomeScene.swift
//  WWDC17
//
//  Created by Salman Husain on 3/21/17.
//  Copyright © 2017 CarbonDev. All rights reserved.
//

import Foundation
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
                //print("X: \(selected.position.x) y: \(selected.position.y)")
                selected.position.x += touchDelta.x
                selected.position.y = getMoonY(forX: touch.location(in: self).x)
                sunNode!.position.x = selected.position.x+700 //If we trace behind 500 we come up at the right time
                sunNode!.position.y = getMoonY(forX: selected.position.x+700) //again^^
                
                if (Int(selected.position.x) % 4 == 0) {
                    self.backgroundColor = getColorBackground(forX: selected.position.x)
                    //self.run(SKAction.colorize(with: getColorBackground(forX: selected.position.x), colorBlendFactor: 1.0, duration: 0.1))
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
                    var hasMoonTrackCompleted = false;
                    //Begin our track
                    let moonTrack = SKAction.customAction(withDuration: 15, actionBlock: {
                        [unowned self, sunNode]
                        node, time in
                        //We want to stop animating once its off screen for a bit.
                        if (node.position.x > -350) {
                            node.position.y = self.getMoonY(forX: node.position.x - 6)
                            node.position.x -= 6
                            
                            sunNode!.position.x = node.position.x+700 //If we trace behind 500 we come up at the right time
                            sunNode!.position.y = self.getMoonY(forX: node.position.x+700) //again^^
                            
                        }else {
                            //The moon is well off screen. Time to try to present our completion
                            if (!hasMoonTrackCompleted) {
                                //We're done at this point. Change our bool so we only fire once
                                hasMoonTrackCompleted = true;
                                self.addDayProps()
                            }
                        }
                        
                    })
                    
                    //Launch our color to sky and kill the moon
                    self.run(SKAction.colorize(with: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), colorBlendFactor: 1.0, duration: 3))
                    
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
        self.backgroundColor = UIColor.black
        addProps()
        
    }
    
    
    /// Add all our objects and get them setup
    public func addProps() {
        let moon = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "001-moon.png")))
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
        let rotateSun = SKAction.rotate(byAngle: 360, duration: 120)
        sunNode!.run(SKAction.repeatForever(rotateSun))
        self.addChild(sunNode!)
        
        let positionDebugger = SKSpriteNode(color: #colorLiteral(red: 0.7378575206, green: 0.2320150733, blue: 0.1414205134, alpha: 1), size: CGSize(width: 25, height: 25))
        //positionDebugger.name = "positionDebugger"
        self.addChild(positionDebugger)
        
        positionDebugger.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.5)
    }
    
    func addDayProps() {
        let tree1 = createTreeAnimatedAt(forX: 120, treeImage: #imageLiteral(resourceName: "003-tree-3.png"))
        tree1.run(SKAction.move(to: CGPoint(x: 120, y: tree1.frame.height/2), duration: 1), completion: {
            //We've add our first tree. Now add number two.
            let tree2 = self.createTreeAnimatedAt(forX: self.frame.width/2, treeImage: #imageLiteral(resourceName: "006-tree-1.png"))
            tree2.run(SKAction.move(to: CGPoint(x: self.frame.width/2, y: tree2.frame.height/2), duration: 1), completion: {
                //We've add our second tree. Now add number three.
                let tree3 = self.createTreeAnimatedAt(forX: self.frame.width*0.75, treeImage: #imageLiteral(resourceName: "007-tree.png"))
                tree3.run(SKAction.move(to: CGPoint(x: self.frame.width*0.75, y: tree3.frame.height/2), duration: 1), completion: {
                    //We've add final tree.
                    
                    
                    
                    let titleText = SKLabelNode(text: "VISION")
                    titleText.fontSize = 95
                    titleText.fontName = "SinhalaSangamMN-Bold"
                    titleText.color = .white
                    titleText.alpha = 0
                    titleText.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
                    self.addChild(titleText)
                    let continueText = SKLabelNode(text: "continue on the next page")
                    continueText.fontSize = 40
                    continueText.color = #colorLiteral(red: 0.3411357999, green: 0.3411998153, blue: 0.341131717, alpha: 1)
                    continueText.alpha = 0
                    continueText.position = CGPoint(x: self.size.width * 0.5, y: titleText.position.y-continueText.frame.height-25) //Place ourselves 25 below the bototm of the arrow
                    self.addChild(continueText)
                    
                    continueText.run(SKAction.fadeIn(withDuration: 1.5))
                    titleText.run(SKAction.fadeIn(withDuration: 0.5))
                })
            })
        })
    }
    
    func createTreeAnimatedAt(forX:CGFloat, treeImage:UIImage) -> SKSpriteNode {
        let tree = SKSpriteNode(texture: SKTexture(image: treeImage))
        tree.position = CGPoint(x: forX, y: -250)
        tree.setScale(0.5)
        self.addChild(tree)
        return tree
    }
    
    func getMoonY(forX:CGFloat) -> CGFloat {
        //Break up our quadratic into bits because the compiler can't handle a simple quadratic???
        let a:CGFloat = -(1/250)
        let interceptOne = (forX-self.frame.width+100)
        let interceptTwo = (forX-100)
        return a * interceptOne * interceptTwo
        
        
    }
    
    func getColorBackground(forX:CGFloat) ->UIColor {
        let startCoord = 768.0
        let endCoord = 0.0
        let stepSize = 1.0 / (startCoord-endCoord)
        let xPosition = startCoord - Double(forX)
        //let color = colorSequence!.sample(atTime: forX)
        return UIColor.init(colorLiteralRed: Float((69*stepSize*xPosition)/255.0), green: Float((193*stepSize*xPosition)/255.0), blue: Float((244*stepSize*xPosition)/255.0), alpha: 1)
    }
    
    func finishScene(swipe:UISwipeGestureRecognizer) {
        //Resign. This will let the controller regain control of the scene
        PlaygroundPage.current.finishExecution()
        //Dismiss the view?
        PlaygroundPage.current.liveView = nil
    }
    
}


let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 1024, height: 768))

let scene = WelcomeScene(size: sceneView.frame.size)
scene.prepareScene()
sceneView.showsFPS = true
sceneView.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

