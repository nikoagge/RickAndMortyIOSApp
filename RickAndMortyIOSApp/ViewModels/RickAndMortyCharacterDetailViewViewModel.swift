//
//  RickAndMortyCharacterDetailViewViewModel.swift
//  RickAndMortyIOSApp
//
//  Created by Nikos Aggelidis on 28/2/23.
//

import Foundation

final class RickAndMortyCharacterDetailViewViewModel {
    private let rickAndMortyCharacter: RickAndMortyCharacter
    
    public var title: String {
        rickAndMortyCharacter.name.uppercased()
    }
    
    init(rickAndMortyCharacter: RickAndMortyCharacter) {
        self.rickAndMortyCharacter = rickAndMortyCharacter
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}
