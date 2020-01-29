//
//  CharacterDetailsVC.swift
//  MarvelApiApp
//
//  Created by tarek on 1/24/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit
import SVProgressHUD

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

        Messages.instance.showProgressSpinner(message: "loading comics List ... may take a time if offline")
        
        if let selectedCharacter = selectedCharacter  {
            MarvelApi.getCharacterComicsList(character: selectedCharacter) { (error, characterComicsArray) in
            
                if error == nil {
                    if let characterComicsArray = characterComicsArray {
                        self.characterComicsArray = characterComicsArray
                        DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        Messages.instance.dissmissProgrressSpinner()
                        }
                    }
                }else {
                     Messages.instance.showAlertMessage(title: "Error!", message: "Error loading Comics List", controller: self)
                }
            }
        }
    }
    
    
    private func configureViews() {
        if let selectedCharacter = selectedCharacter {
            MarvelApi.getImage(imageView: characterImageView, partialImagePathUrl: selectedCharacter.partialImagePathUrl, isLandscape: true)
            characterNameLbl.text = selectedCharacter.name
            characterDescriptionLbl.text = selectedCharacter.characterDescription
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComicsSlideShowVC" {
            if let comicSlideShowVC = segue.destination as? ComicsSlideShowVC ,
               let selectedCharacter = selectedCharacter   {
               comicSlideShowVC.selectedCharacter = selectedCharacter
            }
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

