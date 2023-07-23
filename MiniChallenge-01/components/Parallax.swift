import SpriteKit
import GameplayKit

class ParallaxItem {
    var depth: Int
    var parallaxNodes: [SKSpriteNode] = []
    
    init(fileName: String, depth: Int) {
        self.depth = depth
        
        let texture = SKTexture(imageNamed: fileName)
        let node = SKSpriteNode(texture: texture)
        
        node.zPosition = CGFloat(-depth)
        node.physicsBody = SKPhysicsBody(edgeLoopFrom: node.frame)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = 0
        node.physicsBody?.categoryBitMask = 0
        
        parallaxNodes.append(node)
    }
        
    
    func update(scene: BaseLevelScene) {
        
        applyOffset(scene: scene)
        fillParallax(scene: scene)
        
    }
    
    func fillParallax(scene: BaseLevelScene) {
        
        var indexToRemove: [Int] = [ ]
        
        for index in 0..<parallaxNodes.count {
            
            let node = parallaxNodes[index]
            
            let camera = scene.camera!
            
                
            let rightOfCamera = camera.position.x + scene.frame.size.width / 2
                let rightOfNode = node.position.x + node.size.width / 2
                
            let leftOfCamera = camera.position.x - scene.frame.size.width / 2
                let leftOfNode = node.position.x - node.size.width / 2
                
                let isVisible = !(rightOfNode > rightOfCamera && leftOfNode > rightOfCamera) && !(leftOfNode < leftOfCamera && rightOfNode < leftOfCamera)
                
                if (index == parallaxNodes.count - 1) {
                    
                    if (rightOfNode < rightOfCamera) {
                        let otherNode = node.copy() as! SKSpriteNode
                        otherNode.position.x = node.position.x + node.size.width
                        scene.addChild(otherNode)
                        
                        parallaxNodes.append(otherNode)
                    }
                    
                }
                
                if (index == 0 && leftOfNode > leftOfCamera) {
                    
                    let otherNode = node.copy() as! SKSpriteNode
                    otherNode.position.x = node.position.x - node.size.width
                    scene.addChild(otherNode)
                    
                    parallaxNodes.insert(otherNode, at: 0)
                }
                
                if (!isVisible) {
                    node.removeFromParent()
                    indexToRemove.append(index)
                }
        
        }
        
    }
    
    func applyOffset(scene: BaseLevelScene) {
        let cameraController = scene.cameraController
        
        for node in parallaxNodes {
            node.physicsBody?.velocity.dx = -(cameraController!.cameraVelocity.dx - CGFloat(depth))
            node.physicsBody?.velocity.dy = -(cameraController!.cameraVelocity.dy - CGFloat(depth))
        }
    }
    
    
}


class Parallax {
    
    var scene: BaseLevelScene
    var items: [ParallaxItem]
    
    init(scene: BaseLevelScene, items: [ParallaxItem]) {
        self.scene = scene
        self.items = items
        
        setup()
    }
    
    func setup() {
        
        for item in items {
            let nodes = item.parallaxNodes
            
            for node in nodes {
                node.position = scene.cameraController.camera.position
                
                scene.addChild(node)
            }
        }
        
    }
    
    func update() {
        
        for item in items {
            item.update(scene: scene)
        }
        
    }
    
    
}
