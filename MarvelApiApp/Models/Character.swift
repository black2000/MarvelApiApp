//
//  Character.swift
//  MarvelApiApp
//
//  Created by tarek on 1/24/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import Foundation

class Character {
    
    let id : Int
    let name : String
    let partialImagePathUrl  : String
    
    
    init(id : Int , name : String , partialImagePathUrl : String ) {
        self.id = id
        self.name = name
        self.partialImagePathUrl  = partialImagePathUrl
    }
    

}
