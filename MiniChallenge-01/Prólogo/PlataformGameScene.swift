//
//  PlataformGame.swift
//  EstudandoSpriteKit
//
//  Created by Gabriel Eirado on 11/07/23.
//

import Foundation
import SpriteKit

class PlataformGameScene: SKScene, SKPhysicsContactDelegate{
    
    
    private let player = Player()
    private var ground = Ground()
    private var plataform: SKSpriteNode = SKSpriteNode()

    private var virtualControllerB = ControllerBack()
    private var virtualControllerF = ControllerFront()
    private var jump = JumpButton()
    
    private var joystickInUse: Bool = false
    private var selectedNodes: [UITouch:SKSpriteNode] = [:]
    
//    let cameraController = CameraController(camera, player, boundaries)
    
    var controls: [String: ()] = [:]
    var distanceX: CGFloat = 0
    var distanceY: CGFloat = 0
    var joystickTouch: UITouch?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.gray
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.view?.isMultipleTouchEnabled = true


        addPlayer()
        addGround()
        addPlataform()
        addController()
        addJumpB()
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            
            let location = t.location(in: self)
            
            let touchedNode = self.atPoint(t.location(in: self))
            
            let controls: [String: () -> Void] = [
                "jump": applyJump
            ]
            
            if let nodeName = touchedNode.name {
                if (controls.contains{ $0.key == nodeName }) {
                    controls[nodeName]!()
                }
            }
            
            if virtualControllerF.frame.contains(location){
                 
                joystickInUse = true
                self.joystickTouch = t
                print("move")
          }
        }
    }
    
    func movementPossible(){
        joystickInUse = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
 
        for t in touches{
          if touches.first == t{
                let location = t.location(in: self)
                
                //            print(t == self.joystickTouch)  verifica se o toque foi o mesmo
                if joystickInUse{
                    
                    let point = CGPoint(x: location.x - virtualControllerB.position.x, y: location.y - virtualControllerB.position.y).normalize()
                    
                    let angle = atan2(point.y, point.x)
                    
                    let distanceFromCenter = CGFloat(virtualControllerB.frame.size.width / 2) // limita o botao pequeno
                    
                    distanceX = CGFloat(sin(angle - CGFloat.pi / 2) * distanceFromCenter) * -1
                    distanceY = CGFloat(cos(angle - CGFloat.pi / 2) * -distanceFromCenter) * -1
                    
                    let xDirection: CGFloat = distanceX < 0 ? -1 : 1
                    player.xScale = xDirection
                    // raiz de 2 - 1
                    
                    let radiusB = virtualControllerB.size.width / 2
                    
                    if  location.x * 0.75 > radiusB && location.y * 1.2 > radiusB && location.y * 0.85 < radiusB * 2 && location.x * 0.8 < radiusB * 2.5 {
                        
                        virtualControllerF.position = location
                        
                    }else{
                        
                        virtualControllerF.position = CGPoint(x: virtualControllerB.position.x + distanceX, y: virtualControllerB.position.y + distanceY)
                        
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first != nil{
            for t in touches{
                if t == self.joystickTouch {
                    
                    let moveback = SKAction.move(to: CGPoint(x: virtualControllerB.position.x, y: virtualControllerB.position.y), duration: 0.1)
                    moveback.timingMode = .linear
                    virtualControllerF.run(moveback)
                    joystickInUse = false
                    
                }
            }
        }
    }
 
    override func update(_ currentTime: TimeInterval) {

        if !joystickInUse{
            
            distanceX = 0
            
        }
        
        applyMovement()
    }
    
    func applyMovement(){
        
        player.physicsBody!.velocity.dx = distanceX * 4
        
    }
    
    func applyJump(){
        
        player.physicsBody?.applyImpulse(CGVector(dx: player.size.width, dy: player.size.height * 0.5))
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
        
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        self.addChild(player)
        
    }
    
    func addGround(){
        
        ground.position = CGPoint(x: size.width * 0.5 , y: size.height * 0.1 - ground.size.height)
        self.addChild(ground)
        
    }
    
    func addController(){
        
        virtualControllerB.position = CGPoint(x: size.width * 0.2 * 0.8, y: size.height * 0.3 * 0.8)
        virtualControllerF.position = CGPoint(x: size.width * 0.2  * 0.8, y: size.height * 0.3 * 0.8)

        self.addChild(virtualControllerB)
        self.addChild(virtualControllerF)
        
    }
    
    func addJumpB(){
        
        jump.position = CGPoint(x: size.width * 0.8, y: size.height * 0.3 * 0.8)
        self.addChild(jump)
        
    }
}
