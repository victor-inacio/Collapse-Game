//
//  Persistence.swift
//  MiniChallenge
//
//  Created by Leonardo Mesquita Alves on 25/07/23.
//

import Foundation
import SpriteKit

// Criação do sistema de persistência
let userDefaults = UserDefaults.standard
var minDeadCount = userDefaults.integer(forKey: "minDeadCount")
var commonDeadCount = userDefaults.integer(forKey: "commonDeadCount")
var levelName = userDefaults.string(forKey: "highLevelName")
var winGame = userDefaults.bool(forKey: "winGame")

extension SKScene{
    
    // Determina a persistência para o maior level que o jogador chegou
    func setUserDefaults(_ a : String){
        userDefaults.set(a, forKey: "highLevelName")
    }
    
    // Determina a persistência para o maior level como nula
    func setUserDefaults(){
        userDefaults.set(nil, forKey: "highLevelName")
    }
    
    // Reinicia um userDefaults genêrico
    func resetUserDefaults(_ a: String){
        userDefaults.set(nil, forKey: a)
    }
}

extension Player{
    // Altera a quantidade de mortes do player
    func setDieUserDefault(_ a : Int){
        userDefaults.set(a, forKey: "commonDeadCount")
    }
}
