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

class MarvelApi {
    
    static let publicApiKey = "8ae573e721dc704a5787e13a8a1cd0a8"
    static let privateApiKey = "d54f4bd160851841f4bfe3700bd2c9b1942e6bc0"
    static let ts = Date.timeIntervalSinceReferenceDate.description
    
  
    
    enum EndPoints {
        
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
            return URL(string: stringValue)!
        }
    }
    
    
    
    class func getCharacterList(offset : Int, startWith : String?, completion : @escaping (_ error : Error? ,_ charactersArray : [Character]?) -> ()) {
        
        var url : URL
        
        if let startWith = startWith {
           url = EndPoints.getCharactersListWithMatchedName(offset,startWith).url
        }else {
           url = EndPoints.getCharactersList(offset).url
        }
        
        
        Alamofire.request(url).responseJSON { (response) in
            
           var characterArray = [Character]()
            
           guard response.error == nil else {
                completion(response.error , nil)
                return
           }
            
            
            if  let baseDictionary =  response.result.value as? [String : Any]
               ,let dataDictionary = baseDictionary["data"] as? [String : Any]
               ,let resultArray = dataDictionary["results"] as? [[String : Any]] {
                    for resultDictionary in resultArray {
                        if let id = resultDictionary["id"] as? Int ,
                           let name = resultDictionary["name"] as? String ,
                           let description = resultDictionary["description"] as? String ,
                           let thumbnailDictionary = resultDictionary["thumbnail"] as? [String : Any],
                           let partialImagePathUrl = thumbnailDictionary["path"] as? String {
                            let character = Character(id: id, name: name, description: description, partialImagePathUrl: partialImagePathUrl)
                                characterArray.append(character)
                            }
                     }
                completion(nil , characterArray)
            }
       }
    }
    
    
    
   class func getImage( imageView : UIImageView , partialImagePathUrl : String , isLandscape : Bool , completion : @escaping () -> () ) {
        
    let imageUrl = isLandscape ?  EndPoints.getLandscapeImage(partialImagePathUrl).url :
                                  EndPoints.getStandardImage(partialImagePathUrl).url
   
        Alamofire.request(imageUrl).responseImage { response in
            
            if let image = response.result.value {
                DispatchQueue.main.async {
                     imageView.image = image
                }
                completion()
            }
        }
   }
    
    
    class func getCharacterComicsList(characterId : Int, completion : @escaping (_ error : Error? ,_ characterComicsArray : [Comic]?) -> ()) {
        
         print(EndPoints.getCharacterComics(characterId).url)
        Alamofire.request(EndPoints.getCharacterComics(characterId).url).responseJSON { (response) in
            
           
            print(response.result)
            
            var characterComicsArray = [Comic]()
            
            guard response.error == nil else {
                completion(response.error , nil)
                return
            }
            
            
            if  let baseDictionary =  response.result.value as? [String : Any]
                ,let dataDictionary = baseDictionary["data"] as? [String : Any]
                ,let resultArray = dataDictionary["results"] as? [[String : Any]] {
                for resultDictionary in resultArray {
                    if let id = resultDictionary["id"] as? Int ,
                        let name = resultDictionary["title"] as? String ,
                        let thumbnailDictionary = resultDictionary["thumbnail"] as? [String : Any],
                        let partialImagePathUrl = thumbnailDictionary["path"] as? String {
                        let comic = Comic(id: id, name: name, partialImagePathUrl: partialImagePathUrl)
                        characterComicsArray.append(comic)
                    }
                }
                completion(nil , characterComicsArray)
            }
        }
    }
    
    
    
    
    


}
