//
//  RickAndMortyGetAllCharactersResponse.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 25/2/23.
//

import Foundation

struct RickAndMortyGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RickAndMortyCharacter]
}
