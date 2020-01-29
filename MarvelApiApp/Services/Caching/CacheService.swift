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
import Kingfisher


class CacheService {
    
    static let instance = CacheService()
    
    func saveCharacterInDataBase(character : Character ) {
        
        
        let realm = try! Realm()
        try! realm.write {
            let existingCharacter = realm.objects(Character.self).filter("id == %@", character.id).first
           
            if existingCharacter == nil {
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
           
           let existingComic = realm.objects(Comic.self).filter("id == %@", comic.id).first
           
           if existingComic == nil {
                 realm.add(comic)
           }
        }
    }
    
    func loadCharacterComicsFromDataBase(character : Character) -> [Comic] {
        
        let realm = try! Realm()
        
        let characterComicsListArray = realm.objects(Comic.self).filter({$0.characterId == character.id})
        
        return Array(characterComicsListArray)
    }
    
    func cacheImage(imageView : UIImageView , imageUrl : URL ) {
        imageView.kf.setImage(with: imageUrl)
    }
    
}
