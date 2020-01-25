//
//  ViewController.swift
//  MarvelApiApp
//
//  Created by tarek on 1/23/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit
import SwiftHash


class CharactersListVC: UIViewController  {

    
    var characterArray = [Character]()
    
    var searchBarNav = UISearchBar()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupSearchbarNav()
        loadCharacterList(startWith: nil)
    }
    
    
    private func loadCharacterList(startWith : String?) {
       
        MarvelApi.getCharacterList(startWith: startWith) { (error, characterArray) in
            if error == nil {
                if let characterArray = characterArray {
                    self.characterArray = characterArray
                    self.tableView.reloadData()
                }
            }else {
                print(error!)
            }
        }
    }
    
    
    
    private func setupSearchbarNav() {
        searchBarNav.delegate = self
        navigationItem.titleView = searchBarNav
        DispatchQueue.main.async {
            self.searchBarNav.isHidden = true
        }
    }
    
    private func toggleSearchBar(show : Bool ) {
        
         DispatchQueue.main.async {
            self.searchBarNav.setShowsCancelButton(show, animated: true)
            self.searchBarNav.isHidden = show ? false : true
            self.searchBarNav.text =  ""
            self.searchBarNav.placeholder = show ? "search..." : ""
            
            self.searchBtn.title = show ?   "" : "search"
            self.searchBtn.isEnabled = show ? false : true
         }
        
    }
    
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        
        toggleSearchBar(show: true)
        self.characterArray.removeAll()
        self.tableView.reloadData()
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
    
    
    
}






extension CharactersListVC : UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            
            let startWith = searchBar.text != "" ? searchBar.text : nil
            self.loadCharacterList(startWith: startWith)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        toggleSearchBar(show: false)
        loadCharacterList(startWith: nil)
    }

}





