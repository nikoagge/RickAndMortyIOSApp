//
//  RickAndMortyCharactersViewController.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 18/2/23.
//

import UIKit

final class RickAndMortyCharactersViewController: UIViewController {
    private let rickAndMortyCharactersListView = RickAndMortyCharactersListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

private extension RickAndMortyCharactersViewController {
    func setupUI() {
        setupRickAndMortyCharactersListView()
    }
    
    func setupRickAndMortyCharactersListView() {
        rickAndMortyCharactersListView.delegate = self
        view.addSubview(rickAndMortyCharactersListView)
        NSLayoutConstraint.activate([
            rickAndMortyCharactersListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rickAndMortyCharactersListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rickAndMortyCharactersListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rickAndMortyCharactersListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RickAndMortyCharactersViewController: RickAndMortyCharactersListViewDelegate {
    func rickAndMortyCharactersListView(_ rickAndMortyCharactersListView: RickAndMortyCharactersListView, didSelectRickAndMortyCharacter rickAndMortyCharacter: RickAndMortyCharacter) {
        let rickAndMortyCharacterDetailViewViewModel = RickAndMortyCharacterDetailViewViewModel(rickAndMortyCharacter: rickAndMortyCharacter)
        let rickAndMortyCharacterDetailViewController = RickAndMortyCharacterDetailViewController(rickAndMortyCharacterDetailViewViewModel: rickAndMortyCharacterDetailViewViewModel)
        rickAndMortyCharacterDetailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(rickAndMortyCharacterDetailViewController, animated: true)
    }
}
