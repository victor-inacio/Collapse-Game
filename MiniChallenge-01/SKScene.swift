//
//  SkScene.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 17/07/23.
//

import SpriteKit
import GameplayKit

extension BaseLevelScene{
    func giveTileMapPhysicsBodyFallen(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
        let proportion = (textureWidth / tileMapProportion)
        
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
                        
    
                        self.addChild(tileNode)
                    } else{
                        self.addChild(tileNode)
                        tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x , y: tileNode.position.y + startingLocation.y)
                    }
                    
                    let entity = Fallen1Entity(node: tileNode)
                    
                    triggersManager.addComponent(foundIn: entity)
                    fallenBlocksManager.addComponent(foundIn: entity)
                    self.entities.append(entity)
                }
            }
        }
    }
    
    func giveTileMapPhysicsBodyFloor(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
        let proportion = (textureWidth / tileMapProportion)
        
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
                        tileNode.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue

                        
                        tileNode.position = CGPoint(x: (tileNode.position.x + startingLocation.x) - (0.5 * (sizeOfThePhysicsBody[row] - 1) * Double(tileTexture.size().width/proportion)) , y: tileNode.position.y + startingLocation.y)
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
    
    func giveTileMapPhysicsBodyWall(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
        let proportion = (textureWidth / tileMapProportion)
        
        //Basico do collision do tilemap
        let tileMap = map
        let startingLocation:CGPoint = tileMap.position
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat (tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        //Lógica para a criação de node de colisão maiores
        
        var array: [[Bool]] = Array(repeating: Array(repeating: false, count: tileMap.numberOfRows), count: tileMap.numberOfColumns)
        var canCreatePhysicsBody = false
        var sizeOfThePhysicsBody: [Double] = Array(repeating: 0, count: tileMap.numberOfColumns)
        
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row){
                    array[col][row] = true
                } else{
        
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
                    if row < tileMap.numberOfRows - 1{
                        if array[col][row + 1] == false && array[col][row] == true{
                            sizeOfThePhysicsBody[col] += 1
                            canCreatePhysicsBody = true
                            
                        } else if array[col][row] == true && array[col][row+1] == true{
                            canCreatePhysicsBody = false
                            sizeOfThePhysicsBody[col] += 1
                        }
                    } else if row == tileMap.numberOfRows - 1{
                        if array[col][row] == true{
                            sizeOfThePhysicsBody[col] += 1
                            canCreatePhysicsBody = true
                        }
                    }
                    
                    
                    
                    
                    
//                    Physics Body
                    if  canCreatePhysicsBody{
                        tileNode.anchorPoint = CGPoint(x: 0.5 , y: 0.5 - ((sizeOfThePhysicsBody[col] - 1) * 0.5))
                        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (tileTexture.size().width/proportion), height: (tileTexture.size().height/proportion) * sizeOfThePhysicsBody[col]  ))
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.isDynamic = false
                        tileNode.physicsBody?.friction = 0
                        tileNode.physicsBody?.linearDamping = 100
                        
                        tileNode.position = CGPoint(x: (tileNode.position.x + startingLocation.x) , y: tileNode.position.y + startingLocation.y - (0.5 * (sizeOfThePhysicsBody[col] - 1) * Double(tileTexture.size().height/proportion)))
                        sizeOfThePhysicsBody[col] = 0
                        self.addChild(tileNode)
                    } else{
                        self.addChild(tileNode)
                        tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x , y:    tileNode.position.y + startingLocation.y)
                    }
                    
                }
            }
        }
    }
    
    func giveTileMapPhysicsBodyWater(map: SKTileMapNode, textureWidth: Double, tileMapProportion: Double){
        
        let proportion = (textureWidth / tileMapProportion)
        
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
                        tileNode.physicsBody?.collisionBitMask = 0
                        tileNode.physicsBody?.categoryBitMask = PhysicsCategory.water.rawValue
                        
                        
                        
                        tileNode.position = CGPoint(x: (tileNode.position.x + startingLocation.x) - (0.5 * (sizeOfThePhysicsBody[row] - 1) * Double(tileTexture.size().width/proportion)) , y: tileNode.position.y + startingLocation.y)
                        sizeOfThePhysicsBody[row] = 0
                        self.addChild(tileNode)
                    } else{
                        self.addChild(tileNode)
                        tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x , y: tileNode.position.y + startingLocation.y)
                    }
                    
                    let waterEntity = WaterEntity(node: tileNode)
                    
                    
                    tileNode.entity = waterEntity
                    
                    
                    self.triggersManager.addComponent(foundIn: waterEntity)
                    self.entities.append(waterEntity)
                }
            }
        }
    }
}
