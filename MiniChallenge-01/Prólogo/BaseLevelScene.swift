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
    var parallaxNodes: [SKSpriteNode] = []
    
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

 
        
        if let parallaxNode = childNode(withName: "parallax") as? SKSpriteNode {
            
            parallaxNodes.append(parallaxNode)
        }
        
        

        let boundaries = getBoundaries()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: boundaries!.frame)
        
        let spawnPoint = getSpawnPoint()
        player.node.position = spawnPoint
        
        addChild(camera2)
        camera2.addChild(virtualController)
        
        cameraController = CameraController(camera: self.camera!, target: player.node, boundaries: boundaries)
        
        setupDoors()
        
        let nuvensTexture = SKTexture(imageNamed: "Nuvens2")
        let nuvensNode = SKSpriteNode(texture: nuvensTexture)
        
        nuvensNode.position = camera!.position
        
        parallaxNodes.append(nuvensNode)
        
        addChild(nuvensNode)
    
        for node in parallaxNodes {
            
            node.physicsBody = SKPhysicsBody(edgeLoopFrom: node.frame)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.allowsRotation = false
            node.physicsBody?.isDynamic = true
            node.physicsBody?.collisionBitMask = 0
            node.physicsBody?.contactTestBitMask = 0
            node.physicsBody?.categoryBitMask = 0
            
        }
        

        for node in self.children {
            if (node.name == "Floor"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyFloor(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                    someTileMap.removeFromParent()
                }
            } else if (node.name == "Wall"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyWall(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                    someTileMap.removeFromParent()
                }
            } else if (node.name == "Fallen2") {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyFallenBlocks(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                    someTileMap.removeFromParent()
                }
            }
            
            if (node.name == "Fallen"){
                    if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                        giveTileMapPhysicsBodyFallen(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                        someTileMap.removeFromParent()
                    }
                }
            
            if (node.name == "Water"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyWater(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                    someTileMap.removeFromParent()
                }
            }
        }
    }

    
    func updateParallax() {
       
        applyOffset()
        fillParallax()
    }
    
    func fillParallax() {
        
        var indexToRemove: [Int] = [ ]
        
        for index in 0..<parallaxNodes.count {
            
            let node = parallaxNodes[index]
            
            if let camera = self.camera {
                
                let rightOfCamera = camera.position.x + frame.size.width / 2
                let rightOfNode = node.position.x + node.size.width / 2
                
                let leftOfCamera = camera.position.x - frame.size.width / 2
                let leftOfNode = node.position.x - node.size.width / 2
                
                let isVisible = !(rightOfNode > rightOfCamera && leftOfNode > rightOfCamera) && !(leftOfNode < leftOfCamera && rightOfNode < leftOfCamera)
                
                if (index == parallaxNodes.count - 1) {
                    
                    if (rightOfNode < rightOfCamera) {
                        let otherNode = node.copy() as! SKSpriteNode
                        otherNode.position.x = node.position.x + node.size.width
                        addChild(otherNode)
                        
                        parallaxNodes.append(otherNode)
                    }
                    
                }
                
                if (index == 0 && leftOfNode > leftOfCamera) {
                    
                    let otherNode = node.copy() as! SKSpriteNode
                    otherNode.position.x = node.position.x - node.size.width
                    addChild(otherNode)
                    
                    parallaxNodes.insert(otherNode, at: 0)
                }
                
                if (!isVisible) {
                    node.removeFromParent()
                    indexToRemove.append(index)
                }
            }
        }
        
    }
    
    func applyOffset() {
        for node in parallaxNodes {
            node.physicsBody?.velocity.dx = -cameraController.cameraVelocity.dx
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
        
        updateParallax()
        cameraController.update(currentTime)
        
        if canCreatePhysicsBody{
            for node in self.children {
                if (node.name == "FallenCreating"){
                    if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                        self.giveTileMapPhysicsBodyFallenBlocks(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
                        self.canCreatePhysicsBody = false
                    }

                    var waiting = SKAction.wait(forDuration: 0.485)
                    
                    if timeVariance == 0{
                        waiting = SKAction.wait(forDuration: 0.40)
                        timeVariance += 1
                    }else if timeVariance < 4{
                        waiting = SKAction.wait(forDuration: 0.485)
                        timeVariance += 1
                    } else{
                        waiting = SKAction.wait(forDuration: 0.505 * 3)
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
           
        let nodeA = contact.bodyA.node as? SKSpriteNode
           let nodeB = contact.bodyB.node as? SKSpriteNode
        
           for triggerComponent in triggersManager.components {
               
               if let triggerNode = triggerComponent.entity?.component(ofType: SpriteComponent.self)?.node {
   
                   if triggerNode == nodeA {
                 
                       triggerComponent.callback(nodeB)
                   }
   
                   if triggerNode == nodeB {
                
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
    self.addChild(player.node)
}

func addGround(){
    
    ground.position = CGPoint(x: size.width * 0.5 , y: size.height * 0.1 - ground.size.height)
    self.addChild(ground)
    
}

}
