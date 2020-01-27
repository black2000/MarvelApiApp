//
//  ViewController.swift
//  MarvelApiApp
//
//  Created by tarek on 1/23/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit
import SwiftHash
import SVProgressHUD


class CharactersListVC: UIViewController  {

    
    var characterArray = [Character]()
    var isSearching = false
    var nameStartWith : String? = nil
    var offset =  0
    
    
    var isOffline = false 
    
    var searchBarNav = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
       
        configureViews()
        loadCharacterList(offset: offset, startWith: nil)
    }
    
    
    private func loadCharacterList(offset : Int,startWith : String?) {
       
        SVProgressHUD.setBackgroundColor( .black)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setBorderWidth(4.0)
        SVProgressHUD.show(withStatus: "loading character List ...")
       
        
        MarvelApi.getCharacterList(offset: offset, startWith: startWith) { (error, isOffline ,characterArray) in
            if error == nil {
                if let characterArray = characterArray {
                    self.characterArray.append(contentsOf: characterArray)
                    self.isOffline = isOffline
                    
                    DispatchQueue.main.async {
                         self.tableView.reloadData()
                         SVProgressHUD.dismiss()
                    }
                }
            }else {
                print(error!)
            }
        }
        
       
    }
    
    
    
    private func configureViews() {
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "marvelLogo"))
        
        searchBarNav.delegate = self
       
        DispatchQueue.main.async {
            self.searchBarNav.isHidden = true
        }
    }
    
    private func toggleSearchBar(show : Bool ) {
        
         DispatchQueue.main.async {
            
            
            self.navigationItem.titleView = show ?  self.searchBarNav : UIImageView(image: UIImage(named: "marvelLogo"))
            
            self.searchBarNav.setShowsCancelButton(show, animated: true)
            self.searchBarNav.isHidden = show ? false : true
            self.searchBarNav.text =  ""
            self.searchBarNav.placeholder = show ? "search..." : ""
            
            self.searchBtn.tintColor = show ?   .black : .red
            self.searchBtn.isEnabled = show ? false : true
            
            
            self.characterArray.removeAll()
            self.tableView.reloadData()
            
            self.offset = 0
            self.isSearching = show ? true : false
         }
        
    }
    
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        toggleSearchBar(show: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCharacterDetailsVC" {
            if let characterDetailsVC = segue.destination as? CharacterDetailsVC ,
               let selectedCharacter = sender as? Character {
                characterDetailsVC.selectedCharacter = selectedCharacter
            }
        }
    }
    
    

}

extension CharactersListVC : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell") as? CharacterCell {
            let character = characterArray[indexPath.row]
            cell.configureCells(character: character)
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCharacter = characterArray[indexPath.row]
        performSegue(withIdentifier: "toCharacterDetailsVC", sender: selectedCharacter)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexpath = self.tableView.indexPathsForVisibleRows?.last
        
        if (indexpath?.last == self.characterArray.count - 1 ) && !isOffline {
            offset += 20
            
            if isSearching {
                loadCharacterList(offset: offset, startWith: nameStartWith)
            }else {
                loadCharacterList(offset: offset, startWith: nil)
            }
        }
    }
    

    
    
    
    
    
    
    
}






extension CharactersListVC : UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            self.offset = 0
            let startWith = searchBar.text != "" ? searchBar.text : nil
            self.nameStartWith = startWith
            self.characterArray.removeAll()
            self.tableView.reloadData()
            self.loadCharacterList(offset: self.offset, startWith: self.nameStartWith)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        print("hello")
        toggleSearchBar(show: false)
        loadCharacterList(offset: offset, startWith: nil)
    }

}





