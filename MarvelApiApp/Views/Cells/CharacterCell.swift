//
//  CharacterCell.swift
//  MarvelApiApp
//
//  Created by tarek on 1/24/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    
    func configureCells(character : Character) {
        
        characterName.text = character.name
        MarvelApi.getImage(imageView: characterImageView, partialImagePathUrl: character.partialImagePathUrl, isLandscape: true) {
            
        }
        
    }
    
    

}
