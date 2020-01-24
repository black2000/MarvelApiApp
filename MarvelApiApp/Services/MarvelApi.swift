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
        
        case getCharactersList
        case getCharactersListWithMatchedName(String)
        case getCharacterstandardImage(String)
        case getCharacterlandscapeImage(String)
        
        var stringValue : String {
            switch self {
            case .getCharactersList:
                return EndPoints.base + "/characters" + EndPoints.publicApiParam+EndPoints.tsParam+EndPoints.hashParam
            
            case .getCharactersListWithMatchedName(let nameStartWith):
                return EndPoints.base + "/characters" + EndPoints.publicApiParam+EndPoints.tsParam+EndPoints.hashParam + "&nameStartsWith=\(nameStartWith)"
                
            case .getCharacterstandardImage(let imagePath) :
                return imagePath + "/standard_fantastic.jpg"
                
            case .getCharacterlandscapeImage(let imagePath) :
                    return imagePath + "/landscape_amazing.jpg"
            
                
            }
        }
        var url : URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
    class func getCharacterList(startWith : String?, completion : @escaping (_ error : Error? ,_ charactersArray : [Character]?) -> ()) {
        
        var url : URL
        
        if let startWith = startWith {
           url = EndPoints.getCharactersListWithMatchedName(startWith).url
        }else {
           url = EndPoints.getCharactersList.url
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
                           let thumbnailDictionary = resultDictionary["thumbnail"] as? [String : Any] ,
                           let partialImagePathUrl = thumbnailDictionary["path"] as? String {
                                let character = Character(id: id, name: name, partialImagePathUrl: partialImagePathUrl)
                                characterArray.append(character)
                            }
                     }
                completion(nil , characterArray)
            }
       }
    }
    
    
    
   class func getCharacterImage( imageView : UIImageView , partialImagePathUrl : String , isLandscape : Bool , completion : @escaping () -> () ) {
        
    let imageUrl = isLandscape ?  EndPoints.getCharacterlandscapeImage(partialImagePathUrl).url :
                                  EndPoints.getCharacterstandardImage(partialImagePathUrl).url
   
        
        Alamofire.request(imageUrl).responseImage { response in
            
            if let image = response.result.value {
                DispatchQueue.main.async {
                     imageView.image = image
                }
                completion()
            }
        }
   }


}
