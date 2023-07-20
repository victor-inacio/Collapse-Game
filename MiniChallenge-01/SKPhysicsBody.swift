
import SpriteKit


extension SKPhysicsBody
{
    override open func copy() -> Any {
        guard let body = super.copy() as? SKPhysicsBody else {fatalError("SKPhysicsBody.copy() failed")}
        body.affectedByGravity = affectedByGravity
        body.allowsRotation = allowsRotation
        body.isDynamic = isDynamic
        body.mass = mass
        body.density = density
        body.friction = friction
        body.restitution = restitution
        body.linearDamping = linearDamping
        body.angularDamping = angularDamping
        
        return body
    }
}
