//
//  DataBase.swift
//  MarvelApiApp
//
//  Created by tarek on 1/26/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


class Database {
    
    static let instance = Database()
    
    func saveCharacterInDataBase(character : Character ) {
        let realm = try! Realm()
        try! realm.write {
            
           let existingComic = realm.objects(Character.self).filter("id == %@", character.id).first
            
            if existingComic == nil {
                realm.add(character)
            }
            
        }
    }
    
    func loadCharacterListFromDataBase() -> [Character] {
        let realm = try! Realm()
        let characterListArray = realm.objects(Character.self)
        
        return Array(characterListArray)
    }
    
    func saveCharacterComicsInDataBase( character : Character , comic: Comic) {
        let realm = try! Realm()
        try! realm.write {
          
        //let existingComic = realm.objects(Comic.self).filter("id == %@", comic.id).first
        
          let existingComic = character.comics.filter("id == %@", comic.id).first
            
            
           if existingComic == nil {
                 character.comics.append(comic)
            }
        
        }
    }
    
    func loadCharacterComicsFromDataBase(character : Character) -> [Comic] {
        print("prining eeeeee")
        print(character)
        let characterComicsListArray = character.comics
        return Array(characterComicsListArray)
    }
    
    
    
    
    
}
