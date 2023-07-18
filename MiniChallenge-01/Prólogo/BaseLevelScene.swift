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
    private var ground = Ground()
    
    private var plataform: SKSpriteNode = SKSpriteNode()
    
    private var selectedNodes: [UITouch:SKSpriteNode] = [:]
    
    var controls: [String: ()] = [:]
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
        
        virtualController = VirtualController(target: self.player, scene: self)
        
        
        let boundaries = getBoundaries()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: boundaries!.frame)
        
        let spawnPoint = getSpawnPoint()
        player.playerNode.position = spawnPoint
        
        
        addChild(camera2)
        camera2.addChild(virtualController)
        
        cameraController = CameraController(camera: self.camera!, target: player.playerNode, boundaries: boundaries)
        
        setupDoors()
        
        for node in self.children {
            if (node.name == "Floor"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyFloor(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                    someTileMap.removeFromParent()
                }
            }
            
            if (node.name == "Fallen"){
                    if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                        giveTileMapPhysicsBodyFallen(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                        someTileMap.removeFromParent()
                    }
                }
            }
        
    }
    
    func getBoundaries() -> SKSpriteNode? {
        let boundaries = childNode(withName: "Boundaries") as? SKSpriteNode
        
        return boundaries
    }
    
    func getSpawnPoint() -> CGPoint {
        
        let spawnPointNode = childNode(withName: "SpawnPoint")
        
        
        let position = spawnPointNode?.position ?? CGPoint(x: 0, y: 0)
        
        
        return position
    }
    
    func addTriggerToNode(node: SKSpriteNode, callback: @escaping () -> Void) {
        let entity = GKEntity()
        
        entity.addComponent(SpriteComponent(node: node))
        entity.addComponent(TriggerComponent(callback: { node in
            callback()
        }))
        triggersManager.addComponent(foundIn: entity)
        
        self.entities.append(entity)
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
           let nodeA = contact.bodyA.node as? SKSpriteNode
           let nodeB = contact.bodyB.node as? SKSpriteNode
           for triggerComponent in triggersManager.components {
   
               print(contact.bodyA.node, contact.bodyB.node)
               
               if let triggerNode = triggerComponent.entity?.component(ofType: SpriteComponent.self)?.node {
   
                   if triggerNode == nodeA {
                       print(nodeB)
                       triggerComponent.callback(nodeB)
                   }
   
                   if triggerNode == nodeB {
                       print(nodeA)
                       triggerComponent.callback(nodeA)
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
