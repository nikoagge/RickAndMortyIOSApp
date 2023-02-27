//
//  RickAndMortyCharacterCollectionViewCellViewModel.swift
//  RickAndMortyIOSApp
//
//  Created by Nikos Aggelidis on 26/2/23.
//

import Foundation

final class RickAndMortyCharacterCollectionViewCellViewModel {
    public let characterName: String
    private let characterStatus: RickAndMortyCharacterStatus
    private let characterImageURL: URL?
    
    public var characterStatusText: String {
        return characterStatus.rawValue
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
        
        let characterImageURLRequest = URLRequest(url: characterImageURL)
        URLSession.shared.dataTask(with: characterImageURLRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
