//
//  RickAndMortyLocation.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 18/2/23.
//

import Foundation

struct RickAndMortyLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
