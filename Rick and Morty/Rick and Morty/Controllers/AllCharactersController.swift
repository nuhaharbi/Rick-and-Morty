//
//  AllCharactersController.swift
//  Rick and Morty
//
//  Created by Nuha Alharbi on 16/05/1444 AH.
//

import UIKit
import Kingfisher
import Alamofire

class AllCharactersController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    // MARK: - Vars
    
    let apiURLString = "https://rickandmortyapi.com/api/character/"
    var sections : [CollectionViewSection] = [CollectionViewSection(sectionTitle: "Alive", characters: []),
                                  CollectionViewSection(sectionTitle: "Dead", characters: []),
                                  CollectionViewSection(sectionTitle: "Unknown", characters: [])]

    // MARK: - App lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Task{
            async let alive: () = getData(apiURL: "\(apiURLString)?status=alive", charactersStatus: .Alive)
            async let dead: () = getData(apiURL: "\(apiURLString)?status=dead", charactersStatus: .Dead)
            async let unknown: () = getData(apiURL: "\(apiURLString)?status=unknown", charactersStatus: .Unknown)
            
            try await (alive, dead, unknown)
            
            DispatchQueue.main.async {
                self.charactersCollectionView.reloadData()
            }
        }

        setUpCollectionView()
        
    }
    
    // MARK: - Functions
    
    func getData(apiURL: String, charactersStatus: Status) async throws {
        let data = try await AF.request(apiURL, method: .get).serializingDecodable(RickAndMortyData.self).value
        sections[charactersStatus.rawValue].characters.append(contentsOf: data.results)
        
        if let next = data.info.next {
           try await getData(apiURL: next, charactersStatus: charactersStatus)
        } else {
            return
        }
    }
    
    func setUpCollectionView() {
        charactersCollectionView.collectionViewLayout = CollectionViewLayouts.allCharactersLayouts()
        charactersCollectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "header" , withReuseIdentifier: "myHeader" )
    }
}

// MARK: - Extention

extension AllCharactersController : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.characterImage.kf.setImage(with: URL(string:sections[indexPath.section].characters[indexPath.row].image))
        cell.characterName.text = sections[indexPath.section].characters[indexPath.row].name
        cell.layer.cornerRadius = 12
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myHeader", for: indexPath) as? HeaderCollectionReusableView else {
            return UICollectionViewCell()
        }
        
        header.sectionTitle.text = sections[indexPath.section].sectionTitle
        header.layer.cornerRadius = 10
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let charInfoVC = mainStoryBoard.instantiateViewController(withIdentifier: "info") as? CharacterInfoViewController else { return }
        charInfoVC.character = sections[indexPath.section].characters[indexPath.row]
        navigationController?.pushViewController(charInfoVC, animated: true)
        
    }
    
}

