//
//  RickAndMortyCharacterStatus.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 19/2/23.
//

import Foundation

enum RickAndMortyCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
}
