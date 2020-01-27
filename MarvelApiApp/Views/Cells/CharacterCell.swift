//
//  CharacterCell.swift
//  MarvelApiApp
//
//  Created by tarek on 1/24/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterCell: UITableViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    
    
    
    
    
    func configureCells(character : Character) {
        
        characterName.text = character.name
        characterImageView.kf.setImage(with: URL(string :"http://x.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73/landscape_amazing.jpg"))
        
        MarvelApi.getImage(imageView: characterImageView, partialImagePathUrl: character.partialImagePathUrl, isLandscape: true) 
        
    }
    
    

}
