//
//  RickAndMortyCharactersListView.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 25/2/23.
//

import UIKit

protocol RickAndMortyCharactersListViewDelegate: AnyObject {
    func rickAndMortyCharactersListView(
        _ rickAndMortyCharactersListView: RickAndMortyCharactersListView,
        didSelectRickAndMortyCharacter rickAndMortyCharacter: RickAndMortyCharacter
    )
}

final class RickAndMortyCharactersListView: UIView {
    private let rickAndMortyCharactersListViewViewModel = RickAndMortyCharactersListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RickAndMortyCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RickAndMortyCharacterCollectionViewCell.identifier)
        collectionView.register(
            RickAndMortyFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RickAndMortyFooterLoadingCollectionReusableView.identifier
        )
        
        return collectionView
    }()
    
    public weak var delegate: RickAndMortyCharactersListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        spinner.startAnimating()
        rickAndMortyCharactersListViewViewModel.delegate = self
        rickAndMortyCharactersListViewViewModel.fetchRickAndMortyCharacters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}

private extension RickAndMortyCharactersListView {
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
        setupCollectionView()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupCollectionView() {
        collectionView.dataSource = rickAndMortyCharactersListViewViewModel
        collectionView.delegate = rickAndMortyCharactersListViewViewModel
    }
}

extension RickAndMortyCharactersListView: RickAndMortyCharactersListViewViewModelDelegate {
    func didLoadInitialRickAndMortyCharacters() {
        collectionView.reloadData()
        spinner.stopAnimating()
        collectionView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath ]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectRickAndMortyCharacter(_ rickAndMortyCharacter: RickAndMortyCharacter) {
        delegate?.rickAndMortyCharactersListView(self, didSelectRickAndMortyCharacter: rickAndMortyCharacter)
    }
}
