//
//  ComicsSlideShowVC.swift
//  MarvelApiApp
//
//  Created by tarek on 1/27/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComicsSlideShowVC: UIViewController {

    var selectedCharacter : Character?
    var characterComicsArray = [Comic]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        loadCharacterComics()
    }
    

    private func loadCharacterComics() {
        
        SVProgressHUD.setBackgroundColor( .black)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setBorderWidth(4.0)
        SVProgressHUD.show(withStatus: "loading comics List ...")
        
        if let selectedCharacter = selectedCharacter  {
            MarvelApi.getCharacterComicsList(character: selectedCharacter) { (error, characterComicsArray) in
                
                if error == nil {
                    if let characterComicsArray = characterComicsArray {
                        self.characterComicsArray = characterComicsArray
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            SVProgressHUD.dismiss()
                        }
                        
                    }
                    
                }else {
                    print(error)
                }
            }
        }
    }
    
    
    
    
    

}

extension ComicsSlideShowVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterComicsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicSlideShowCell", for: indexPath) as? ComicSlideShowCell {
            let comic = characterComicsArray[indexPath.row]
            cell.configureCell(comic: comic)
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
}
