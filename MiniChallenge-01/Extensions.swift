//
//  ExtensionTileMapCollision.swift
//  MiniChallenge-01
//
//  Created by Leonardo Mesquita Alves on 14/07/23.
//

import SpriteKit

//extension SKScene{
//    func giveTileMapPhysicsBody (map: SKTileMapNode ){
//        let tileMap = map
//        let startingLocation:CGPoint = tileMap.position
//        let tileSize = tileMap.tileSize
//        let halfWidth = CGFloat (tileMap.numberOfColumns) / 2.0 * tileSize.width
//        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
//
//        //Lógica para a criação de node de colisão maiores
//        var multiplierWidth = 1.0
//        let anchorPointX = 0.5
//
//        for col in 0..<tileMap.numberOfColumns {
//
//            for row in 0..<tileMap.numberOfRows {
//
//                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
//                    let tileArray = tileDefinition.textures
//                    let tileTexture = tileArray[0]
//                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
//                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
//                    print("\(x), \(y)")
//                    let tileNode = SKSpriteNode(texture:tileTexture)
//                    tileNode.scale(to: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
//                    tileNode.position = CGPoint(x: x, y: y)
//                    tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:(tileTexture.size().width * multiplierWidth), height: (tileTexture.size().height)))
//                    tileNode.physicsBody?.affectedByGravity = false
//                    tileNode.physicsBody?.allowsRotation = false
//                    tileNode.physicsBody?.isDynamic = false
//                    tileNode.physicsBody?.categoryBitMask = physicsCategory.floorPhysics.rawValue
//                    tileNode.physicsBody?.collisionBitMask = physicsCategory.playerPhysics.rawValue
//                    tileNode.physicsBody?.friction = 0
//                    tileNode.physicsBody?.linearDamping = 100
//
//                    self.addChild(tileNode)
//                    tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x, y: tileNode.position.y + startingLocation.y)
//
//                }
//                print("FIM DA INTERAÇAO")
//            }
//        }
//    }
//}


extension SKScene{
    func giveTileMapPhysicsBody (map: SKTileMapNode ){
        
        //Basico do collision do tilemap
        let tileMap = map
        let startingLocation:CGPoint = tileMap.position
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat (tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        //Lógica para a criação de node de colisão maiores
        
        var array: [[Bool]] = Array(repeating: Array(repeating: false, count: tileMap.numberOfRows), count: tileMap.numberOfColumns)
        var canCreatePhysicsBody = false
        var sizeOfThePhysicsBody: [Double] = Array(repeating: 0, count: tileMap.numberOfRows)
        
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                    array[col][row] = true
                    print("\(col), \(row) = true")
                } else{
                    print("\(col), \(row) = false")
                }
            }
        }
        
        for col in 0..<tileMap.numberOfColumns {
            
            for row in 0..<tileMap.numberOfRows {
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                    let tileArray = tileDefinition.textures
                    let tileTexture = tileArray[0]
                    
                    
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                    
                    
                    
                    
                    //Criação da textura
                    let tileNode = SKSpriteNode(imageNamed: "TesteX")
                    tileNode.scale(to: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                    tileNode.position = CGPoint(x: x, y: y)
                    
                    
                    
                    
                    //Detectar quando precisa fazer um node maior
                    if col < tileMap.numberOfColumns - 1{
                        if array[col + 1][row] == false && array[col][row] == true{
                            sizeOfThePhysicsBody[row] += 1
                            canCreatePhysicsBody = true
                            
                        } else if array[col][row] == true && array[col + 1][row] == true{
                            canCreatePhysicsBody = false
                            sizeOfThePhysicsBody[row] += 1
                        }
                    } else if col == tileMap.numberOfColumns - 1{
                        if array[col][row] == true{
                            sizeOfThePhysicsBody[row] += 1
                            canCreatePhysicsBody = true
                        }
                    }
                    
                    
                    
                    
                    
//                    Physics Body
                    if  canCreatePhysicsBody{
                        tileNode.anchorPoint = CGPoint(x: 0.5 - ((sizeOfThePhysicsBody[row] - 1) * 0.5), y: 0.5)
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (tileTexture.size().width) * (sizeOfThePhysicsBody[row]), height: (tileTexture.size().height)))
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.isDynamic = false
                        tileNode.physicsBody?.friction = 0
                        tileNode.physicsBody?.linearDamping = 100
                        print("\(sizeOfThePhysicsBody[row])")
                        
                        tileNode.position = CGPoint(x: (tileNode.position.x + startingLocation.x) - (0.5 * (sizeOfThePhysicsBody[row] - 1) * Double(tileTexture.size().width)) , y: tileNode.position.y + startingLocation.y)
                        sizeOfThePhysicsBody[row] = 0
                        self.addChild(tileNode)
                    } else{
                        self.addChild(tileNode)
                        tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x , y: tileNode.position.y + startingLocation.y)
                    }
                    
                    
                    
                    
                }
            }
        }
    }
    
    
}
