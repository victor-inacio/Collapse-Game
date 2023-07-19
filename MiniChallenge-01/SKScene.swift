//
//  SkScene.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 17/07/23.
//

import SpriteKit
import GameplayKit


extension BaseLevelScene{
    
    func getTileMapNodes(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double) -> [SKSpriteNode] {
        
        let proportion = (textureWidth / tileMapProportion)
        
        var tileNodes: [SKSpriteNode] = []
        
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
                if tileMap.tileDefinition(atColumn: col, row: row) != nil{
                    array[col][row] = true
                    //                    print("\(col), \(row) = true")
                } else{
                    //                    print("\(col), \(row) = false")
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
                    let tileNode = SKSpriteNode(texture: tileTexture)
                    tileNode.scale(to: CGSize(width: tileTexture.size().width/proportion, height: tileTexture.size().height/proportion))
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
                    
                        
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (tileTexture.size().width/proportion) * (sizeOfThePhysicsBody[row]), height: (tileTexture.size().height/proportion)))
                        
                    
                        
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.isDynamic = false
                        tileNode.physicsBody?.friction = 0
                        tileNode.physicsBody?.linearDamping = 0
                        
                        
                        
                        
                        
                        
                        tileNode.position = CGPoint(x: (tileNode.position.x + startingLocation.x) - (0.5 * (sizeOfThePhysicsBody[row] - 1) * Double(tileTexture.size().width/proportion)) , y: tileNode.position.y + startingLocation.y)
                        sizeOfThePhysicsBody[row] = 0
                        
    
                    } else{
                        tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x , y: tileNode.position.y + startingLocation.y)
                    }
                    
                    tileNodes.append(tileNode)
                }
            }
        }
        
        return tileNodes
        
    }
    
    func giveTileMapPhysicsBodyFallen(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
        let tileNodes = getTileMapNodes(map: map, textureWidth: textureWidth, tileMapProportion: tileMapProportion)
        
        
        for node in tileNodes {
            
            
            
            self.addChild(node)
            
            let entity = GKEntity()
            node.entity = entity
            entity.addComponent(SpriteComponent(node: node))
            entity.addComponent(FallenBlocksComponent())
            
            triggersManager.addComponent(foundIn: entity)
            self.entities.append(entity)
            
            
        }
    }
    
    func giveTileMapPhysicsBodyFloor(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
        let nodes = getTileMapNodes(map: map, textureWidth: textureWidth, tileMapProportion: tileMapProportion)
        
        for node in nodes {
            addChild(node)
        }
    }
    
    
    
    
    func giveTileMapPhysicsBodyWall(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
       let nodes = getTileMapNodes(map: map, textureWidth: textureWidth, tileMapProportion: tileMapProportion)
        
        for node in nodes {
            self.addChild(node)
        }
    }
    
}
