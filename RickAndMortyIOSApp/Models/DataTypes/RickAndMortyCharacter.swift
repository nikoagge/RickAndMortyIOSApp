//
//  RickAndMortyCharacter.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 18/2/23.
//

import Foundation

struct RickAndMortyCharacter: Codable {
    let id: Int
    let name: String
    let status: RickAndMortyCharacterStatus
    let species: String
    let type: String
    let gender: RickAndMortyCharacterGender
    let origin: RickAndMortyOrigin
    let location: RickAndMortySingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
