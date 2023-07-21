//
//  FallenBlocks.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 18/07/23.
//

import SpriteKit

extension SKScene{
    
    func giveTileMapPhysicsBodyFallenBlocks(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
        let proportion = (textureWidth / tileMapProportion)
        
        //Basico do collision do tilemap
        let tileMap = map
        let startingLocation:CGPoint = tileMap.position
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat (tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            
            for row in 0..<tileMap.numberOfRows {
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                    let tileArray = tileDefinition.textures
                    let tileTexture = tileArray[0]
                    
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                    
                    //Criação da textura
                    let tileNode = SKSpriteNode(texture: tileTexture)
                    tileNode.scale(to: CGSize(width: tileTexture.size().width/proportion, height: tileTexture.size().height/proportion))
                    tileNode.position = CGPoint(x: x, y: y)
                    
                    tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (tileTexture.size().width/proportion) - 5 , height: (tileTexture.size().height/proportion) ))
                    tileNode.physicsBody?.mass = 1000
                    tileNode.physicsBody?.affectedByGravity = true
                    tileNode.physicsBody?.allowsRotation = false
                    tileNode.physicsBody?.isDynamic = true
                    tileNode.physicsBody?.linearDamping = 15
                    tileNode.physicsBody?.categoryBitMask = PhysicsCategory.fallenBlocks.rawValue
                    tileNode.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
                    tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
                
                    
                    tileNode.position = CGPoint(x: (tileNode.position.x + startingLocation.x) , y: tileNode.position.y + startingLocation.y)
                    
                    
                    let action = SKAction.wait(forDuration: 16)
                    self.addChild(tileNode)
                    let removeAction = SKAction.run {
                        tileNode.removeFromParent()
                    }
                    let action2 = SKAction.sequence([action, removeAction])
                    run(action2)
                }
            }
        }
    }
}
