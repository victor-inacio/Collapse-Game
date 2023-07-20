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
    var player: Player!
    var virtualController: VirtualController!
    var cameraController: CameraController!
    let camera2 = SKCameraNode()
    var triggersManager: GKComponentSystem<TriggerComponent>!
    var timeVariance: Int = 0
    var canCreatePhysicsBody: Bool = true
    var entities: [GKEntity] = []
    var pauseButton: SKSpriteNode?
    var skull: SKSpriteNode?
    var killCount: SKLabelNode?
    
    override func didMove(to view: SKView) {
        killCount = SKLabelNode(text: "1")
        killCount?.fontName = "Futura Bold"
        pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        skull = SKSpriteNode(imageNamed: "Skull")
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
        camera2.addChild(pauseButton!)
        camera2.addChild(skull!)
        camera2.addChild(killCount!)
        pauseButton?.position = CGPoint(x: -550, y: 240)
        skull?.position = CGPoint(x: 550, y: 240)
        killCount?.position = CGPoint(x: 480, y: 225)
        
        cameraController = CameraController(camera: self.camera!, target: player.node, boundaries: boundaries)
        
        setupDoors()
        
        
        
        
        
        for node in self.children {
            if (node.name == "Water") || (node.name == "Floor"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyFloor(map: someTileMap, textureWidth: 50, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            } else if (node.name == "Wall"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyWall(map: someTileMap, textureWidth: 50, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            } else if (node.name == "Fallen2") {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyFallenBlocks(map: someTileMap, textureWidth: 50, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            }
            
//            if (node.name == "Fallen"){
//                    if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
//                        giveTileMapPhysicsBodyFallen(map: someTileMap, textureWidth: 50, tileMapProportion: 64)
//                        someTileMap.removeFromParent()
//                    }
//                }
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
        if canCreatePhysicsBody{
            for node in self.children {
                if (node.name == "FallenCreating"){
                    if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                        self.giveTileMapPhysicsBodyFallenBlocks(map: someTileMap, textureWidth: 50, tileMapProportion: 64)
                        self.canCreatePhysicsBody = false
                    }

                    var waiting = SKAction.wait(forDuration: 0.485)
                    
                    if timeVariance == 0{
                        waiting = SKAction.wait(forDuration: 0.600)
                        timeVariance += 1
                    }else if timeVariance < 4{
                        waiting = SKAction.wait(forDuration: 0.600)
                        timeVariance += 1
                    } else{
                        waiting = SKAction.wait(forDuration: 0.505 * 6.5)
                        timeVariance = 1
                    }
                    
                    let runAction = SKAction.run{
                        self.canCreatePhysicsBody = true
                        
                    }
                    let sequence = SKAction.sequence([waiting,runAction])
                    run(sequence)
                }
            }
        }
        player.update()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
           
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if (nodeA?.entity is Player) {
            print(nodeA?.entity)
        }
        
        if (nodeB?.entity is Player) {
            print(nodeB?.entity)
        }
        
           for triggerComponent in triggersManager.components {
               
               if let triggerNode = triggerComponent.entity?.component(ofType: SpriteComponent.self)?.node {
   
                   if triggerNode == nodeA {
                 
//                       triggerComponent.callback(nodeB)
                   }
   
                   if triggerNode == nodeB {
                
//                       triggerComponent.callback(nodeA)
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
    
    if let playerT = childNode(withName: "PlayerNode") as? SKSpriteNode{
        player.node.position = CGPoint(x: playerT.position.x, y: playerT.position.y)
    } else{
        player.node.position = CGPoint(x: size.width/2 , y: size.height/2)
    }

    self.addChild(player.node)
    
}

func addGround(){
    
    ground.position = CGPoint(x: size.width * 0.5 , y: size.height * 0.1 - ground.size.height)
    self.addChild(ground)
    
}

}
