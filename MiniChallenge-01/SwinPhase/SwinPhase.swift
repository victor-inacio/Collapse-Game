//
//  SwinPhase.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 24/07/23.
//

import SpriteKit

class SwinPhase: BaseLevelScene{
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        virtualController.jumpButton?.alpha = 0
        player.node.physicsBody?.linearDamping = 1
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if player.node.position.y < (childNode(withName: "Limiting gravity")?.position.y)!{
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 23.8)
        } else if  player.node.position.y > (childNode(withName: "Limiting gravity")?.position.y)!{
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        }
    }
//
//    let VISCOSITY: CGFloat = 6 //Increase to make the water "thicker/stickier," creating more friction.
//        let BUOYANCY: CGFloat = 0.4 //Slightly increase to make the object "float up faster," more buoyant.
//        let OFFSET: CGFloat = 70 //Increase to make the object float to the surface higher.
//        //MARK: -
//        var object: SKSpriteNode!
//        var water: SKSpriteNode!
//
//    override func didMove(to view: SKView){
//        object = SKSpriteNode(color: UIColor.white, size: CGSize(width: 25, height: 50))
//        object.physicsBody = SKPhysicsBody(rectangleOf: object.size)
//        object.position = CGPoint(x: self.size.width/2.0, y: self.size.height-50)
//        self.addChild(object)
//        water = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: self.size.width, height: 300))
//        water.position = CGPoint(x: self.size.width/2.0, y: water.size.height/2.0)
//        water.alpha = 0.5
//        self.addChild(water)
//        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
//    }
//
//    override func update(_ currentTime: CFTimeInterval) {
//            if water.frame.contains(CGPoint(x:object.position.x, y:object.position.y-object.size.height/2.0)) {
//                let rate: CGFloat = 0.01; //Controls rate of applied motion. You shouldn't really need to touch this.
//                let disp = (((water.position.y+OFFSET)+water.size.height/2.0)-((object.position.y)-object.size.height/2.0)) * BUOYANCY
//                let targetPos = CGPoint(x: object.position.x, y: object.position.y+disp)
//                let targetVel = CGPoint(x: (targetPos.x-object.position.x)/(1.0/60.0), y: (targetPos.y-object.position.y)/(1.0/60.0))
//                let relVel: CGVector = CGVector(dx:targetVel.x-object.physicsBody!.velocity.dx*VISCOSITY, dy:targetVel.y-object.physicsBody!.velocity.dy*VISCOSITY);
//                object.physicsBody!.velocity=CGVector(dx:object.physicsBody!.velocity.dx+relVel.dx*rate, dy:object.physicsBody!.velocity.dy+relVel.dy*rate);
//            }
//        }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
//        object.position = (touches.anyObject() as UITouch).locationInNode(self);object.physicsBody!.velocity = CGVectorMake(0, 0)}
}
