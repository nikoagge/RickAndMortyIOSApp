//
//  RickAndMortyCharacterDetailViewController.swift
//  RickAndMortyIOSApp
//
//  Created by Nikos Aggelidis on 28/2/23.
//

import UIKit

final class RickAndMortyCharacterDetailViewController: UIViewController {
    private var rickAndMortyCharacterDetailViewViewModel: RickAndMortyCharacterDetailViewViewModel
    
    init(rickAndMortyCharacterDetailViewViewModel: RickAndMortyCharacterDetailViewViewModel) {
        self.rickAndMortyCharacterDetailViewViewModel = rickAndMortyCharacterDetailViewViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = rickAndMortyCharacterDetailViewViewModel.title
    }
}
