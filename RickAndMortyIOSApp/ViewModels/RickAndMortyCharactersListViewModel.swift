//
//  RickAndMortyCharactersListViewModel.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 25/2/23.
//

import UIKit

final class RickAndMortyCharactersListViewModel: NSObject {
    func fetchRickAndMortyCharacters() {
        RickAndMortyService.shared.execute(.listOfCharactersRequest, expecting: RickAndMortyGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let rickAndMortyGetAllCharactersResponse):
                debugPrint("Example image url: "+String(rickAndMortyGetAllCharactersResponse.results.first?.image ?? "No image"))
                
            case .failure(let error):
                debugPrint(String(describing: error))
            }
        }
    }
}

extension RickAndMortyCharactersListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let rickAndMortyCharacterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RickAndMortyCharacterCollectionViewCell.identifier, for: indexPath) as? RickAndMortyCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        let rickAndMortyCharacterCollectionViewCellViewModel = RickAndMortyCharacterCollectionViewCellViewModel(
            characterName: "Nikos",
            characterStatus: .alive,
            characterImageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        )
        rickAndMortyCharacterCollectionViewCell.configure(with: rickAndMortyCharacterCollectionViewCellViewModel)
        
        return rickAndMortyCharacterCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2

        return CGSize(
            width: width,
            height: width * 1.5)
    }
}
