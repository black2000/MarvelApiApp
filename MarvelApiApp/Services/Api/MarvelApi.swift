//
//  MarvelApi.swift
//  MarvelApiApp
//
//  Created by tarek on 1/24/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftHash
import Kingfisher


class MarvelApi {
    
    private static let publicApiKey = "8ae573e721dc704a5787e13a8a1cd0a8"
    private static let privateApiKey = "d54f4bd160851841f4bfe3700bd2c9b1942e6bc0"
    private static let ts = Date.timeIntervalSinceReferenceDate.description
    
    private enum EndPoints {
        static let base = "https://gateway.marvel.com:443/v1/public"
        static let publicApiParam = "?apikey=\(publicApiKey)"
        static let tsParam = "&ts=\(ts)"
        static let hash = (MD5(ts + privateApiKey + publicApiKey)).lowercased()
        static let hashParam = "&hash=\(hash)"
        
        case getCharactersList(Int)
        case getCharactersListWithMatchedName(Int,String)
        case getStandardImage(String)
        case getLandscapeImage(String)
        case getCharacterComics(Int)
        
        var stringValue : String {
            switch self {
            case .getCharactersList(let offset):
                return EndPoints.base + "/characters" + EndPoints.publicApiParam+EndPoints.tsParam+EndPoints.hashParam+"&offset=\(offset)"
            
            case .getCharactersListWithMatchedName(let offset, let nameStartWith):
                return EndPoints.base + "/characters" + EndPoints.publicApiParam+EndPoints.tsParam+EndPoints.hashParam + "&nameStartsWith=\(nameStartWith)"+"&offset=\(offset)"
                
            case .getStandardImage(let imagePath) :
                return imagePath + "/standard_fantastic.jpg"
                
            case .getLandscapeImage(let imagePath) :
                    return imagePath + "/landscape_amazing.jpg"
                
            case .getCharacterComics(let characterId):
                return EndPoints.base + "/characters/\(characterId)/comics" + EndPoints.publicApiParam+EndPoints.tsParam+EndPoints.hashParam
            }
        }
        
        var url : URL {
            return  URL(string: stringValue)!
        }
    }
    
    class func getCharacterList(offset : Int, startWith : String?, completion : @escaping (_ error : Error? ,_ isOffline : Bool ,_ characterListArray : [Character]?) -> ()) {
        
        var url : URL
        var characterListArray = [Character]()
        
        if let startWith = startWith {
           url = EndPoints.getCharactersListWithMatchedName(offset,startWith).url
        }else {
           url = EndPoints.getCharactersList(offset).url
        }
        
        Alamofire.request(url).responseJSON { (response) in
          guard response.error == nil else {
            guard response.data?.count != 0 else {
                let storedCharacterArray = CacheService.instance.loadCharacterListFromDataBase()
                completion(nil,true, storedCharacterArray)
                return
            }
            completion(response.error , true , nil)
            return
          }
        
           if let json =  response.result.value {
                characterListArray = parseCharacterJson(json: json)
                completion(nil , false ,characterListArray)
            }
       }
    }
    
    class func getImage( imageView : UIImageView , partialImagePathUrl : String , isLandscape : Bool  ) {
        
    let imageUrl = isLandscape ?  EndPoints.getLandscapeImage(partialImagePathUrl).url :
                                  EndPoints.getStandardImage(partialImagePathUrl).url
    
    CacheService.instance.cacheImage(imageView: imageView ,imageUrl: imageUrl )

   }
    
    class func getCharacterComicsList(character : Character, completion : @escaping (_ error : Error? ,_ characterComicsArray : [Comic]?) -> ()) {
        
        Alamofire.request(EndPoints.getCharacterComics(character.id).url).responseJSON { (response) in
            
            var characterComicsArray = [Comic]()
            
            guard response.error == nil else {
                
                guard response.data?.count != 0 else {
                    let storedCharacterComicsArray = CacheService.instance.loadCharacterComicsFromDataBase(character: character)
                    completion(nil,storedCharacterComicsArray)
                    return
                }
                
                completion(response.error , nil)
                return
            }

            if  let json =  response.result.value {
                characterComicsArray  = parseComicJson(json: json, character: character)
                completion(nil , characterComicsArray)
            }
        }
    }
    
    class private func parseCharacterJson(json : Any? ) -> [Character] {
        
        var  characterListArray = [Character]()
        
        if  let baseDictionary =  json as? [String : Any]
            ,let dataDictionary = baseDictionary["data"] as? [String : Any]
            ,let resultArray = dataDictionary["results"] as? [[String : Any]] {
            for resultDictionary in resultArray {
                if let id = resultDictionary["id"] as? Int ,
                    let name = resultDictionary["name"] as? String ,
                    let description = resultDictionary["description"] as? String ,
                    let thumbnailDictionary = resultDictionary["thumbnail"] as? [String : Any],
                    let partialImagePathUrl = thumbnailDictionary["path"] as? String {
                    
                    let character = Character()
                    character.id = id
                    character.name = name
                    character.characterDescription = description
                    character.partialImagePathUrl = partialImagePathUrl
                    
                    characterListArray.append(character)
                    CacheService.instance.saveCharacterInDataBase(character: character)
                }
            }
      }
        return characterListArray
    }
    
    class private func parseComicJson(json : Any? , character : Character ) -> [Comic] {
        
        var  characterComicsArray = [Comic]()
        
        if  let baseDictionary =  json as? [String : Any]
            ,let dataDictionary = baseDictionary["data"] as? [String : Any]
            ,let resultArray = dataDictionary["results"] as? [[String : Any]] {
            for resultDictionary in resultArray {
                if let id = resultDictionary["id"] as? Int ,
                    let name = resultDictionary["title"] as? String ,
                    let thumbnailDictionary = resultDictionary["thumbnail"] as? [String : Any],
                    let partialImagePathUrl = thumbnailDictionary["path"] as? String {
                    
                    let comic = Comic()
                    comic.id = id
                    comic.name = name
                    comic.partialImagePathUrl = partialImagePathUrl
                    
                    CacheService.instance.saveCharacterComicsInDataBase(character: character, comic: comic)
                    characterComicsArray.append(comic)
                }
            }
        }
        return characterComicsArray
    }
    
}
