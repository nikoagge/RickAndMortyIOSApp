//
//  RickAndMortyCharactersListViewModel.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 25/2/23.
//

import UIKit

protocol RickAndMortyCharactersListViewModelDelegate: AnyObject {
    func didLoadInitialRickAndMortyCharacters()
}

final class RickAndMortyCharactersListViewModel: NSObject {
    private var rickAndMortyCharacters: [RickAndMortyCharacter] = [] {
        didSet {
            for rickAndMortyCharacter in rickAndMortyCharacters {
                let rickAndMortyCharacterCollectionViewCellViewModel = RickAndMortyCharacterCollectionViewCellViewModel(
                    characterName: rickAndMortyCharacter.name,
                    characterStatus: rickAndMortyCharacter.status,
                    characterImageURL: URL(string: rickAndMortyCharacter.image)
                )
                rickAndMortyCharacterCollectionViewCellViewModels.append(rickAndMortyCharacterCollectionViewCellViewModel)
            }
        }
    }
    
    private var rickAndMortyCharacterCollectionViewCellViewModels: [RickAndMortyCharacterCollectionViewCellViewModel] = []
    
    public weak var delegate: RickAndMortyCharactersListViewModelDelegate?
    
    func fetchRickAndMortyCharacters() {
        RickAndMortyService.shared.execute(
            .listOfCharactersRequest,
            expecting: RickAndMortyGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let rickAndMortyGetAllCharactersResponse):
                let results = rickAndMortyGetAllCharactersResponse.results
                self?.rickAndMortyCharacters = results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialRickAndMortyCharacters()
                }
                
            case .failure(let error):
                debugPrint(String(describing: error))
            }
        }
    }
}

extension RickAndMortyCharactersListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rickAndMortyCharacterCollectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let rickAndMortyCharacterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RickAndMortyCharacterCollectionViewCell.identifier, for: indexPath) as? RickAndMortyCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        rickAndMortyCharacterCollectionViewCell.configure(with: rickAndMortyCharacterCollectionViewCellViewModels[indexPath.row])
        
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
