//
//  Phase3.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 17/07/23.
//

import Foundation
import SpriteKit
import GameplayKit

////IMPORTANTE
//for node in self.children {
//    if (node.name == "Floor") || (node.name == "Water"){
//        if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
//            giveTileMapPhysicsBodyFloor(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
//            someTileMap.removeFromParent()
//        }
//    } else if (node.name == "Wall"){
//        if let someTileMap:SKTileMapNode = node as? SKTileMapNode{
//            giveTileMapPhysicsBodyWall(map: someTileMap, textureWidth: 50, tileMapProportion: 50)
//            someTileMap.removeFromParent()
//        }
//    }
//}
////IMPORTANTE

//func addPlayer(){
//    if let playerT = childNode(withName: "PlayerNode") as? SKSpriteNode{
//        player.playerNode.position = CGPoint(x: playerT.position.x, y: playerT.position.y)
//    } else{
//        player.playerNode.position = CGPoint(x: size.width/2 , y: size.height/2)
//    }
//
//    self.addChild(player.playerNode)
//
//}


//
//
//class Phase3: SKScene, SKPhysicsContactDelegate{
//
//    //    var camere: SKCameraNode = SKCameraNode()
//
//
//    private var ground = Ground()
//
//    private var plataform: SKSpriteNode = SKSpriteNode()
//
//    private var selectedNodes: [UITouch:SKSpriteNode] = [:]
//
//    var controls: [String: ()] = [:]
//    var canWalk = true
//    var player = Player()
//    var virtualController: VirtualController!
//    var cameraController: CameraController!
//    let camera2 = SKCameraNode()
//    var triggersManager: GKComponentSystem<TriggerComponent>!
//
//    var entities: [GKEntity] = []
//
//    override func didMove(to view: SKView) {
//
//        triggersManager = GKComponentSystem(componentClass: TriggerComponent.self)
//
//        physicsWorld.contactDelegate = self
//        backgroundColor = SKColor.gray
//        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
//        self.view?.isMultipleTouchEnabled = true
//
//        self.camera = camera2
//
//        player = Player()
//        addPlayer()
//        player.applyMachine()
//
//        virtualController = VirtualController(target: self.player)
//
//        virtualController.virtualJoystickB?.position = CGPoint(x: size.width / -3 + size.width / 50 , y: size.height  / -3.7)
//        virtualController.virtualJoystickF?.position = CGPoint(x: size.width / -3 + size.width / 50, y: size.height / -3.7)
//
//        virtualController.jumpButton?.position = CGPoint(x:  size.width / 5 + size.width / 20  , y:  size.height  / -3.7)
//        virtualController.dashButton?.position = CGPoint(x: size.width / 3 - size.width / 200, y: size.height / -9 )
//
//        let boundaries = childNode(withName: "Boundaries") as? SKSpriteNode
//
//        physicsBody = SKPhysicsBody(edgeLoopFrom: boundaries!.frame)
//
//        virtualController.addController()
//
//        virtualController.addJump()
//        virtualController.addDash()
//
//
//
//        addChild(camera2)
//        camera2.addChild(virtualController.hud)
//
//        cameraController = CameraController(camera: self.camera!, target: player.playerNode, boundaries: boundaries)
//
//        setupDoors()
//
//
//    }
//
//        func setupDoors() {
//
//            if let doors = childNode(withName: "doors")?.children as? [SKSpriteNode]
//            {
//
//                for door in doors {
//                    let doorEntity = DoorEntity(node: door)
//
//                    doorEntity.addComponent(DoorComponent())
//                    triggersManager.addComponent(foundIn: doorEntity)
//                    self.entities.append(doorEntity)
//                }
//
//
//            }
//
//        }
//
//        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//            for t in touches{
//
//                let location = t.location(in: camera2)
//
//                if virtualController.jumpButton!.frame.contains(location){
//
//                    virtualController.jumpTouch = t
//
//                    player.jump()
//                }
//
//                if virtualController.dashButton!.frame.contains(location){
//
//                    virtualController.dashTouch = t
//
//                    player.Dash(direction: virtualController.direction)
//                }
//
//
//                virtualController.firstTouch(location: location, touch: t)
//
//            }
//        }
//
//        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//            for t in touches{
//                if touches.first == t{
//                    let location = t.location(in: camera2)
//
//                    virtualController.drag(location: location, player:  player.playerNode)
//                }
//            }
//        }
//
//        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//            player.stateMachine?.enter(PlayerIdle.self)
//
//            if touches.first != nil{
//                for t in touches{
//                    if t == virtualController.joystickTouch {
//
//                        virtualController.movementReset(size: self.size)
//
//                    }
//                }
//            }
//        }
//
//        override func update(_ currentTime: TimeInterval) {
//
//            player.applyMovement(distanceX: virtualController.distanceX)
//
//        }
//
//        override func didFinishUpdate() {
//
//            self.cameraController.onFinishUpdate()
//
//        }
//
//
//
//    }
//
//
