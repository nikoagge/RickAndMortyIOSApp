//
//  RickAndMortyCharacterCollectionViewCellViewModel.swift
//  RickAndMortyIOSApp
//
//  Created by Nikos Aggelidis on 26/2/23.
//

import Foundation

final class RickAndMortyCharacterCollectionViewCellViewModel: Hashable, Equatable {
    public let characterName: String
    private let characterStatus: RickAndMortyCharacterStatus
    private let characterImageURL: URL?
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    init(
        characterName: String,
        characterStatus: RickAndMortyCharacterStatus,
        characterImageURL: URL?
    ) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let characterImageURL = characterImageURL else {
            completion(.failure(URLError(.badURL)))
            
            return
        }
        RickAndMortyImageLoader.shared.downloadImage(characterImageURL, completion: completion)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
    
    static func == (lhs: RickAndMortyCharacterCollectionViewCellViewModel, rhs: RickAndMortyCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
