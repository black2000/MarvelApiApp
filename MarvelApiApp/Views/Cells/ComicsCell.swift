//
//  ComicsCell.swift
//  MarvelApiApp
//
//  Created by tarek on 1/24/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit

class ComicsCell: UICollectionViewCell {
    
    
    @IBOutlet weak var comicImageView: UIImageView!
    
    @IBOutlet weak var comicNameLbl: UILabel!
    
    func configureCells(comic : Comic ) {
        comicNameLbl.text = comic.name
        MarvelApi.getImage(imageView: comicImageView, partialImagePathUrl: comic.partialImagePathUrl, isLandscape: false) {
            
        }
    }
    
}
