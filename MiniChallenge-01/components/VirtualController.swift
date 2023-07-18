//
//  VirtualController.swift
//  MiniChallenge-01
//
//  Created by Gabriel Eirado on 13/07/23.
//

import SpriteKit
import GameplayKit

protocol VirtualControllerTarget {
    
    func onJoystickChange(direction: CGPoint, angle: CGFloat) -> Void
    func onJoystickJumpBtnTouch() -> Void
    func onJoystickDashBtnTouch(direction: CGVector) -> Void
}

class VirtualController: SKNode{
    
    var virtualJoystickB: SKSpriteNode?
    var virtualJoystickF: SKSpriteNode?
    var jumpButton: SKSpriteNode?
    var dashButton: SKSpriteNode?
    
    var joystickInUse: Bool = false
    var joystickTouch: UITouch?
    var jumpTouch: UITouch?
    var dashTouch: UITouch?
    var direction: CGVector = CGVector(dx: 0, dy: 0)
    var joystickAngle: CGFloat = 0
    var distanceX: CGFloat = 0 {
        didSet {
            self.target.onJoystickChange(direction: .init(x: self.distanceX, y: self.distanceY), angle: joystickAngle)
        }
    }
    var distanceY: CGFloat = 0 {
        didSet {
            self.target.onJoystickChange(direction: .init(x: self.distanceX, y: self.distanceY), angle: joystickAngle)
        }
    }
    var gameScene = BaseLevelScene()
    var target: VirtualControllerTarget!
    
    init(target: VirtualControllerTarget, scene: SKScene){
        super.init()
        isUserInteractionEnabled = true
        
        self.target = target
        
        // JOYSTICK
        let textureControllerB = SKTexture(imageNamed: "virtualControllerB")
        let textureControllerF = SKTexture(imageNamed: "virtualControllerF")
        
        virtualJoystickB = SKSpriteNode(texture: textureControllerB, color: .white, size: textureControllerB.size())
        
        virtualJoystickB?.name = "controllerBack"
        virtualJoystickB?.zPosition = 5
        
        virtualJoystickF = SKSpriteNode(texture: textureControllerF, color: .white, size: textureControllerF.size())
        
        virtualJoystickF?.name = "controllerFront"
        virtualJoystickF?.zPosition = 6
        
        // JUMP
        let textureJump = SKTexture(imageNamed: "jump")
        
        jumpButton = SKSpriteNode(texture: textureJump, color: .white, size: textureJump.size())
        
        jumpButton?.name = "jump"
        jumpButton?.zPosition = 6
        
        // DASH
        let textureDash = SKTexture(imageNamed: "dash")
        
        dashButton = SKSpriteNode(texture: textureDash, color: .white, size: textureDash.size())
        
        dashButton?.name = "dash"
        dashButton?.zPosition = 6
        
        virtualJoystickB?.position = CGPoint(x: scene.size.width / -3 + scene.size.width / 50 , y: scene.size.height  / -3.7)
        virtualJoystickF?.position = CGPoint(x: scene.size.width / -3 + scene.size.width / 50, y: scene.size.height / -3.7)
        
        jumpButton?.position = CGPoint(x:  scene.size.width / 5 + scene.size.width / 20  , y:  scene.size.height  / -3.7)
        dashButton?.position = CGPoint(x: scene.size.width / 3 - scene.size.width / 200, y: scene.size.height / -9 )
        
        addJump()
        addDash()
        addController()
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    // JOYSTICK
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches{
            
            let location = t.location(in: parent!)

            if jumpButton!.frame.contains(location){

                jumpTouch = t

                target.onJoystickJumpBtnTouch()
            }

            if dashButton!.frame.contains(location){

                dashTouch = t

                target.onJoystickDashBtnTouch(direction: direction)
            }
  
        
        firstTouch(location: location, touch: t)
        
    }
}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first != nil{
            for t in touches{
                if t == joystickTouch {
                    
                    movementReset(size: scene!.size)
                   
                }
            }
        }
    }
    
    func firstTouch(location: CGPoint, touch: UITouch ){
        
        if virtualJoystickF!.frame.contains(location) && location.x < 0{
            
            joystickInUse = true
            joystickTouch = touch

            
        }
    }
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            if touches.first == t{
                let location = t.location(in: parent!)
                
                drag(location: location)
            }
        }
    }
    
    func drag(location: CGPoint) {
        
        if joystickInUse{
//            print("in use")
            let point = CGPoint(x: location.x - virtualJoystickB!.position.x, y: location.y - virtualJoystickB!.position.y).normalize()
            
            joystickAngle = atan2(point.y, point.x)
            
            direction = CGVector(dx: point.x, dy: point.y)
            
            
            let distanceFromCenter = CGFloat(virtualJoystickB!.frame.size.width / 2) // limita o botao pequeno
            
            distanceX = CGFloat(sin(joystickAngle - CGFloat.pi / 2) * distanceFromCenter) * -1
            distanceY = CGFloat(cos(joystickAngle - CGFloat.pi / 2) * -distanceFromCenter) * -1
            

            //let radiusB = controllerJoystick.virtualControllerB.size.width / 2
            
            if virtualJoystickB!.frame.contains(location){
                //                        -location.x / 4 > radiusB && -location.x / 5.8 < radiusB  &&  -location.y * 0.9 > radiusB  && -location.y / 2.9 < radiusB {
                // 0.8 é o meio até o lado para o x
                
                virtualJoystickF!.position = location
                // -267
                
            }else{
                
                virtualJoystickB!.position = CGPoint(x: virtualJoystickF!.position.x - distanceX , y: virtualJoystickF!.position.y - distanceY)
                
                virtualJoystickF!.position = location
            }
        }
    }
    
    func movementReset(size: CGSize){
        
        let moveback = SKAction.move(to: CGPoint(x: size.width / -3 + size.width / 50, y: size.height  / -3.7), duration: 0.1)
        moveback.timingMode = .linear
        virtualJoystickF?.run(moveback)
        virtualJoystickB?.run(moveback)
        joystickInUse = false
        distanceX = 0
        distanceY = 0
        direction = CGVector(dx: 0, dy: 0)

    }
    
    
    func addController(){
        
        addChild(virtualJoystickB!)
        addChild(virtualJoystickF!)
        
    }
    
    // JUMP
    
    func addJump(){
        addChild(jumpButton!)
    }
    
    
    // DASH
    
    func addDash(){
        
        
        addChild(dashButton!)
        
    }
    
    
}

