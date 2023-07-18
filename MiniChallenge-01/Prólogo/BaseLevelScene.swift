//
//  PlataformGame.swift
//  EstudandoSpriteKit
//
//  Created by Gabriel Eirado on 11/07/23.
//

import Foundation
import SpriteKit
import GameplayKit

class BaseLevelScene: SKScene, SKPhysicsContactDelegate{
    
    //    var camere: SKCameraNode = SKCameraNode()
    
    
    private var ground = Ground()
    
    private var plataform: SKSpriteNode = SKSpriteNode()
    
    private var selectedNodes: [UITouch:SKSpriteNode] = [:]
    
    var controls: [String: ()] = [:]
    var canWalk = true
    var player = Player()
    var virtualController: VirtualController!
    var cameraController: CameraController!
    let camera2 = SKCameraNode()
    var triggersManager: GKComponentSystem<TriggerComponent>!
    
    var entities: [GKEntity] = []
    
    override func didMove(to view: SKView) {
        
        triggersManager = GKComponentSystem(componentClass: TriggerComponent.self)
        
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.gray
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.view?.isMultipleTouchEnabled = true
        
        self.camera = camera2

        player = Player()
        addPlayer()
        player.applyMachine()
        
        virtualController = VirtualController(target: self.player)
        
        virtualController.virtualJoystickB?.position = CGPoint(x: size.width / -3 + size.width / 50 , y: size.height  / -3.7)
        virtualController.virtualJoystickF?.position = CGPoint(x: size.width / -3 + size.width / 50, y: size.height / -3.7)
        
        virtualController.jumpButton?.position = CGPoint(x:  size.width / 5 + size.width / 20  , y:  size.height  / -3.7)
        virtualController.dashButton?.position = CGPoint(x: size.width / 3 - size.width / 200, y: size.height / -9 )
        
        let boundaries = childNode(withName: "Boundaries") as? SKSpriteNode
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: boundaries!.frame)
       
        virtualController.addController()

        addGround()
        addPlataform()
       
        virtualController.addJump()
        virtualController.addDash()
                
       
        
        addChild(camera2)
        camera2.addChild(virtualController.hud)
        
        cameraController = CameraController(camera: self.camera!, target: player.playerNode, boundaries: boundaries)
        
        setupDoors()
        
        for node in self.children {
            if (node.name == "Floor"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyFloor(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                    someTileMap.removeFromParent()
                }
            }
        }

    }
    
    func setupDoors() {
        
        if let doors = childNode(withName: "doors")?.children as? [SKSpriteNode]
            {
                    
            for door in doors {
                let doorEntity = DoorEntity(node: door)
                
                doorEntity.addComponent(DoorComponent())
                triggersManager.addComponent(foundIn: doorEntity)
                self.entities.append(doorEntity)
            }
                
                
            }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            
            let location = t.location(in: camera2)
            
            if virtualController.jumpButton!.frame.contains(location){
                
                virtualController.jumpTouch = t
                
                player.jump()
            }
      
            if virtualController.dashButton!.frame.contains(location){
                
                virtualController.dashTouch = t
                
                player.Dash(direction: virtualController.direction)
            }
  
        
        virtualController.firstTouch(location: location, touch: t)
        
    }
}

override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    for t in touches{
        if touches.first == t{
            let location = t.location(in: camera2)
            
            virtualController.drag(location: location, player:  player.playerNode)
        }
    }
}

override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    player.stateMachine?.enter(PlayerIdle.self)
    
    if touches.first != nil{
        for t in touches{
            if t == virtualController.joystickTouch {
                
                virtualController.movementReset(size: self.size)
               
            }
        }
    }
}

override func update(_ currentTime: TimeInterval) {
    
    player.applyMovement(distanceX: virtualController.distanceX)
    
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
    
    player.playerNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
    self.addChild(player.playerNode)
    
}

func addGround(){
    
    ground.position = CGPoint(x: size.width * 0.5 , y: size.height * 0.1 - ground.size.height)
    self.addChild(ground)
    
}

}
