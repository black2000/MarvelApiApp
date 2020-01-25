//
//  CharacterDetailsVC.swift
//  MarvelApiApp
//
//  Created by tarek on 1/24/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit

class CharacterDetailsVC: UIViewController {
    
    var selectedCharacter : Character?
    var characterComicsArray = [Comic]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var characterNameLbl: UILabel!
    @IBOutlet weak var characterDescriptionLbl: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureViews()
        loadCharacterComics()
    }
    
    
    
    private func loadCharacterComics() {
        if let selectedCharacter = selectedCharacter  {
            MarvelApi.getCharacterComicsList(characterId: selectedCharacter.id) { (error, characterComicsArray) in
                
                
                print(characterComicsArray!)
                
                if error == nil {
                    if let characterComicsArray = characterComicsArray {
                        self.characterComicsArray = characterComicsArray
                        self.collectionView.reloadData()
                    }
                    
                }else {
                    print(error)
                }
            }
        }
    }
    
    
    private func configureViews() {
        if let selectedCharacter = selectedCharacter {
            MarvelApi.getImage(imageView: characterImageView, partialImagePathUrl: selectedCharacter.partialImagePathUrl, isLandscape: true) {
                
            }
            characterNameLbl.text = selectedCharacter.name
            characterDescriptionLbl.text = selectedCharacter.description
        }
    }
    
    
    
    
}


extension CharacterDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterComicsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell", for: indexPath) as? ComicsCell {
            let comic = characterComicsArray[indexPath.row]
            cell.configureCells(comic : comic)
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    
    
    
    
    
    
}

