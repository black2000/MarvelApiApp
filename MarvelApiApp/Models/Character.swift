//
//  Character.swift
//  MarvelApiApp
//
//  Created by tarek on 1/24/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import Foundation

import RealmSwift

class Character : Object {
    
    @objc dynamic var id : Int = 0
    @objc dynamic  var name : String = ""
    @objc dynamic var characterDescription : String = ""
    @objc dynamic var partialImagePathUrl  : String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
