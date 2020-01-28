//
//  ComicSlideShowCell.swift
//  MarvelApiApp
//
//  Created by tarek on 1/27/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit

class ComicSlideShowCell: UICollectionViewCell {

    
    @IBOutlet weak var comicImageView: UIImageView!
    
    @IBOutlet weak var comicTitleLbl: UILabel!
    
    func configureCell(comic : Comic) {
        comicTitleLbl.text = comic.name
        MarvelApi.getImage(imageView: comicImageView, partialImagePathUrl: comic.partialImagePathUrl, isLandscape: false)
    }
    
    
}
