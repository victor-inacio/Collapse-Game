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
    var testNode: SKSpriteNode = SKSpriteNode()
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
        player.node.position = spawnPoint
        
        
        addChild(camera2)
        camera2.addChild(virtualController)
        
        cameraController = CameraController(camera: self.camera!, target: player.node, boundaries: boundaries)
        
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
        
        testNode = childNode(withName: "test") as! SKSpriteNode
        
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
        entity.addComponent(TriggerComponent(callback: {
            callback()
        }))
        triggersManager.addComponent(foundIn: entity)
        
        self.entities.append(entity)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let camera = self.camera {
            
        
            
            let parteDireitaDoParallax = testNode.position.x + testNode.size.width / 2
            
            let parteDireitaDaCamera = camera.position.x + self.frame.size.width / 2
            
            
            if (parteDireitaDoParallax < parteDireitaDaCamera) {
                let clone = testNode.copy() as! SKSpriteNode
                
                clone.position.x = parteDireitaDoParallax + clone.size.width / 2
                clone.anchorPoint = .init(x: 0, y: 0.5)
                clone.color = .blue
                clone.alpha = 0.2
                
                self.addChild(clone)
            }
            
        }
        
        player.update()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
           let nodeA = contact.bodyA.node
           let nodeB = contact.bodyB.node
           for triggerComponent in triggersManager.components {
   
               if let triggerNode = triggerComponent.entity?.component(ofType: SpriteComponent.self)?.node {
   
                   if triggerNode == nodeA {
                       triggerComponent.callback()
                   }
   
                   if triggerNode == nodeB {
                       triggerComponent.callback()
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
    
    player.node.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
    self.addChild(player.node)
    
}

func addGround(){
    
    ground.position = CGPoint(x: size.width * 0.5 , y: size.height * 0.1 - ground.size.height)
    self.addChild(ground)
    
}

}
