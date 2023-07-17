//
//  PlataformGame.swift
//  EstudandoSpriteKit
//
//  Created by Gabriel Eirado on 11/07/23.
//

import Foundation
import SpriteKit
import GameplayKit

class PlataformGameScene: SKScene, SKPhysicsContactDelegate{
    
    //    var camere: SKCameraNode = SKCameraNode()
    
    private let player = Player()
    private var ground = Ground()
    
    private var plataform: SKSpriteNode = SKSpriteNode()
    
    private var selectedNodes: [UITouch:SKSpriteNode] = [:]
    
    var controls: [String: ()] = [:]
    var canWalk = true
    
    var virtualController: VirtualController!
    var cameraController: CameraController!
    let camera2 = SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.gray
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.view?.isMultipleTouchEnabled = true
        
        self.camera = camera2
        
        cameraController = CameraController(camera: self.camera!, target: player.player, boundaries: nil)
        virtualController = VirtualController(camera: camera2)
   
        virtualController.virtualJoystickB.position = CGPoint(x: size.width / -3 + size.width / 50 , y: size.height  / -3.7)
        virtualController.virtualJoystickF.position = CGPoint(x: size.width / -3 + size.width / 50, y: size.height / -3.7)
        
        virtualController.jumpButton.position = CGPoint(x:  size.width / 5 + size.width / 20  , y:  size.height  / -3.7)
        virtualController.dashButton.position = CGPoint(x: size.width / 3 - size.width / 200, y: size.height / -9 )
        
        player.applyMachine()
        
        
        addPlayer()
        addGround()
        addPlataform()
        virtualController.addController()
        virtualController.addJump()
        virtualController.addDash()
        
        print(virtualController.virtualJoystickB.position)
        
        addChild(camera2)
        camera2.addChild(virtualController.hud)
        
        print( " ---> \(virtualController.jumpButton.position.y)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            
            let location = t.location(in: camera2)
            
            virtualController.applyJump(location: location, touch: t)

            virtualController.applyDash(location: location, touch: t)

            virtualController.firstTouch(location: location, touch: t)

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            if touches.first == t{
                let location = t.location(in: camera2)
                
                virtualController.drag(location: location, player:  player.player)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first != nil{
            for t in touches{
                if t == virtualController.joystickTouch {
                    
                    virtualController.movementReset(size: self.size)
                    
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
//        if !virtualController.joystickInUse {
//
//            virtualController.distanceX = 0
//
//        }
        
        //        print(direction)
        
//        print(virtualController.distanceX)
        virtualController.applyMovement()
        
    }
    
    override func didFinishUpdate() {
        
        self.cameraController.onFinishUpdate()
        
    }
    
    
    func addPlataform(){
        
        plataform = SKSpriteNode(imageNamed: "plataform")
        plataform.position = CGPoint(x: size.width * 0.8 , y: size.height * 0.2 + plataform.size.height)
        plataform.zPosition = 1
        plataform.physicsBody = SKPhysicsBody(texture: plataform.texture!, size: plataform.size)
        plataform.physicsBody?.affectedByGravity = false
        plataform.physicsBody?.isDynamic = false
        
        addChild(plataform)
        
    }
    
    func addPlayer(){
        
        player.player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        self.addChild(player.player)
        
    }
    
    func addGround(){
        
        ground.position = CGPoint(x: size.width * 0.5 , y: size.height * 0.1 - ground.size.height)
        self.addChild(ground)
        
    }
}

