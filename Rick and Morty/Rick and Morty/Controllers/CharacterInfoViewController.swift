//
//  CharacterInfoViewController.swift
//  Rick and Morty
//
//  Created by Nuha Alharbi on 16/05/1444 AH.
//

import UIKit
import Kingfisher
import Alamofire

class CharacterInfoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var characterInfoCollectionView: UICollectionView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    // MARK: - Vars
    
    var character : Character?
    var characterInfo = [(String, Any)]()
    var characterEpisode : [String] = []
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCharacterInfo()
        characterInfoCollectionView.collectionViewLayout = CollectionViewLayouts.characterInfoLayouts()
    }
    
    // MARK: - Functions
    
     func setUpCharacterInfo() {
        guard let character = character else {return}
        characterInfo = character.allProprities()
        characterInfo = Array(characterInfo[3...characterInfo.count-1])
        characterEpisode = character.episode
        characterImage.kf.setImage(with: URL(string: character.image))
        characterName.text = character.name
         
        Task {
            try await getEpisodes()
            characterInfoCollectionView.reloadData()
        }
    }
    
    func getEpisodes() async throws {
        for (key, episode) in characterEpisode.enumerated() {
            let data = try await AF.request(episode, method: .get).serializingDecodable(Episode.self).value
            characterEpisode[key] = data.episode
        }
    }
}

// MARK: - Extentions

extension CharacterInfoViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 1 ? characterEpisode.count : characterInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCell", for: indexPath) as? PersonalInfoCell else {
                return UICollectionViewCell()
            }
            
            cell.infoName.text = characterInfo[indexPath.row].0

            if let origin = characterInfo[indexPath.row].1 as? Origin {
                cell.infoDetail.text = origin.name
            } else if let location = characterInfo[indexPath.row].1 as? Location {
                cell.infoDetail.text = location.name
            } else {
                cell.infoDetail.text = characterInfo[indexPath.row].1 as? String
            }
            if cell.infoDetail.text == "" {cell.infoDetail.text = "Unknown"}
            cell.layer.cornerRadius = 12
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "epCell", for: indexPath) as? EpisodeCell else {
                return UICollectionViewCell()
            }
            
            cell.episodeTitle.text = characterEpisode[indexPath.row]
            cell.layer.cornerRadius = 8
            return cell
        }
    }
}

