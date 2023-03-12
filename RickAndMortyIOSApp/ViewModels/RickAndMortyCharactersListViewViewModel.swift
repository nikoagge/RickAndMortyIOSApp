//
//  RickAndMortyCharactersListViewViewModel.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 25/2/23.
//

import UIKit

protocol RickAndMortyCharactersListViewViewModelDelegate: AnyObject {
    func didLoadInitialRickAndMortyCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectRickAndMortyCharacter(_ rickAndMortyCharacter: RickAndMortyCharacter)
}

final class RickAndMortyCharactersListViewViewModel: NSObject {
    private var rickAndMortyCharacters: [RickAndMortyCharacter] = [] {
        didSet {
            for rickAndMortyCharacter in rickAndMortyCharacters {
                let rickAndMortyCharacterCollectionViewCellViewModel = RickAndMortyCharacterCollectionViewCellViewModel(
                    characterName: rickAndMortyCharacter.name,
                    characterStatus: rickAndMortyCharacter.status,
                    characterImageURL: URL(string: rickAndMortyCharacter.image)
                )
                
                if !rickAndMortyCharacterCollectionViewCellViewModels.contains(rickAndMortyCharacterCollectionViewCellViewModel) {
                    rickAndMortyCharacterCollectionViewCellViewModels.append(rickAndMortyCharacterCollectionViewCellViewModel)
                }
            }
        }
    }
    
    private var rickAndMortyCharacterCollectionViewCellViewModels: [RickAndMortyCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RickAndMortyGetAllCharactersResponse.Info? = nil
    
    private var isLoadingMoreCharacters = false
    
    public weak var delegate: RickAndMortyCharactersListViewViewModelDelegate?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    func fetchRickAndMortyCharacters() {
        RickAndMortyService.shared.execute(
            .listOfCharactersRequest,
            expecting: RickAndMortyGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let rickAndMortyGetAllCharactersResponse):
                let results = rickAndMortyGetAllCharactersResponse.results
                self?.rickAndMortyCharacters = results
                self?.apiInfo = rickAndMortyGetAllCharactersResponse.info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialRickAndMortyCharacters()
                }
                
            case .failure(let error):
                debugPrint(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalRickAndMortyCharacters(url: URL) {
        guard !isLoadingMoreCharacters else { return }
        isLoadingMoreCharacters = true
        guard let rickAndMortyRequest = RickAndMortyRequest(url: url) else {
            isLoadingMoreCharacters = false
            
            return
        }
        
        RickAndMortyService.shared.execute(
            rickAndMortyRequest,
            expecting: RickAndMortyGetAllCharactersResponse.self) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.apiInfo = info
                    let originalCount = self.rickAndMortyCharacters.count
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    let startinIndex = total - newCount
                    let indexPathsToAdd: [IndexPath] = Array(startinIndex..<(startinIndex+newCount)).compactMap {
                        return IndexPath(row: $0, section: 0)
                    }
                    self.rickAndMortyCharacters.append(contentsOf: moreResults)
                    DispatchQueue.main.async {
                        self.delegate?.didLoadMoreCharacters(
                            with: indexPathsToAdd
                        )
//                        self.isLoadingMoreCharacters = false
                    }
                case .failure(let failure):
                    self.isLoadingMoreCharacters = false
                }
            }
    }
}

extension RickAndMortyCharactersListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectRickAndMortyCharacter(rickAndMortyCharacters[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
                let rickAndMortyFooterLoadingCollectionReusableView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RickAndMortyFooterLoadingCollectionReusableView.identifier,
                    for: indexPath
                ) as? RickAndMortyFooterLoadingCollectionReusableView else { fatalError("Unsupported") }
        rickAndMortyFooterLoadingCollectionReusableView.startAnimating()
        
        return rickAndMortyFooterLoadingCollectionReusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else { return .zero }
        
        return CGSize(
            width: collectionView.frame.width,
            height: 100
        )
    }
}

extension RickAndMortyCharactersListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
                !isLoadingMoreCharacters,
                !rickAndMortyCharacterCollectionViewCellViewModels.isEmpty,
                let nextURLString = apiInfo?.next,
                let nextURL = URL(string: nextURLString) else { return }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= totalContentHeight - totalScrollViewFixedHeight - 120 {
                self?.fetchAdditionalRickAndMortyCharacters(url: nextURL)
            }
            
            timer.invalidate()
        }
    }
}
