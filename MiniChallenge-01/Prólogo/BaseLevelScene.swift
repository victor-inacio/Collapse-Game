//
//  PlataformGame.swift
//  EstudandoSpriteKit
//
//  Created by Gabriel Eirado on 11/07/23.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFAudio

class BaseLevelScene: SKScene, SKPhysicsContactDelegate{
    var shine = SKShapeNode()
    private var plataform: SKSpriteNode = SKSpriteNode()
    
    private var selectedNodes: [UITouch:SKSpriteNode] = [:]
    
    var controls: [String: ()] = [:]
    var player: Player!
    var virtualController: VirtualController!
    var cameraController: CameraController!
    let camera2 = SKCameraNode()
    var triggersManager: GKComponentSystem<TriggerComponent>!
    var fallenBlocksManager: GKComponentSystem<FallenBlocksComponent>!
    var timeVariance: Int = 0
    var canCreatePhysicsBody: Bool = true
    var entities: [GKEntity] = []
    
    var pauseButton: SKSpriteNode?
    var skull: SKSpriteNode?
    var killCount: SKLabelNode?
    var parallax: Parallax!
    var isFallenWaterCreated: Bool = false
    
    override func didMove(to view: SKView) {
        triggersManager = GKComponentSystem(componentClass: TriggerComponent.self)
        fallenBlocksManager = GKComponentSystem(componentClass: FallenBlocksComponent.self)
        
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
    
        
        createFallenWater()


        for node in self.children {
            if (node.name == "Floor"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyFloor(map: someTileMap, textureWidth: 64, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            } else if (node.name == "Wall"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyWall(map: someTileMap, textureWidth: 64, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            } else if (node.name == "Fallen2"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyFallenBlocks(map: someTileMap, textureWidth: 50, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            }
            
            if (node.name == "Fallen"){
                    if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                        giveTileMapPhysicsBodyFallen(map: someTileMap, textureWidth: 64, tileMapProportion: 64)
                        someTileMap.removeFromParent()
                    }
                }
            
            if (node.name == "Water"){
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
                    giveTileMapPhysicsBodyWater(map: someTileMap, textureWidth: 64, tileMapProportion: 64)
                    someTileMap.removeFromParent()
                }
            }
        }
        
        setUserDefaults(self.name ?? "sfsdf")
        
        for node in self.children{
            if node.name == "Limit"{
                let newNode = SKSpriteNode(color: .blue, size: CGSize(width: node.frame.width, height: node.frame.height))
                newNode.position = node.position
                newNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.width, height: node.frame.height))
                newNode.physicsBody?.affectedByGravity = false
                newNode.physicsBody?.isDynamic = false
                newNode.physicsBody?.allowsRotation = false
                newNode.physicsBody?.categoryBitMask = PhysicsCategory.limit.rawValue
                newNode.physicsBody?.contactTestBitMask = PhysicsCategory.water.rawValue
                
                addChild(newNode)
            }
        }
        
    }

    
   
        
    func getBoundaries() -> SKSpriteNode? {
        let boundaries = childNode(withName: "Boundaries") as? SKSpriteNode
        
        return boundaries
    }
    
    func resetLevel() {
        
        for comp in fallenBlocksManager.components {
            comp.reset()
        }
        
    }
    
    func getSpawnPoint() -> CGPoint {
        let spawnPointNode = childNode(withName: "SpawnPoint")
        
        let position = spawnPointNode?.position ?? CGPoint(x: 0, y: 0)
        
        virtualController.movementReset(size: scene!.size)
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
        
        
        virtualController.actualDeadNumber()
        
        applyingForceToFallWater()
    
        cameraController.update(currentTime)
        
        
        player.update()
        
        creatingLimitesForTheScene()
        
        
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
    
    func asd() {
        player.node.position = getSpawnPoint()
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

    
    
    
}
