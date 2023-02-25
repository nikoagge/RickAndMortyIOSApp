//
//  RickAndMortyRequest.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 19/2/23.
//


import Foundation

final class RickAndMortyRequest {
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    private let endpoint: RickAndMortyEndpoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var urlString = Constants.baseUrl
        urlString += "/"
        urlString += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                urlString += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            urlString += "?"
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            urlString += argumentString
        }
        
        return urlString
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    public init(
        endpoint: RickAndMortyEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension RickAndMortyRequest {
    static let listOfCharactersRequest = RickAndMortyRequest(endpoint: .character)
}
