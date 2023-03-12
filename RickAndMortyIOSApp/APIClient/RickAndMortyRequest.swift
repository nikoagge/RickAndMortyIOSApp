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
    
    convenience init?(url: URL) {
        let urlString = url.absoluteString
        if !urlString.contains(Constants.baseUrl) {
            return nil
        }
        let trimmedURLString = urlString.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmedURLString.contains("/") {
            let components = trimmedURLString.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                if let rickAndMortyEndpoint = RickAndMortyEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rickAndMortyEndpoint)
                    
                    return
                }
            }
        } else if trimmedURLString.contains("?") {
            let components = trimmedURLString.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else { return nil }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                }
                if let rickAndMortyEndpoint = RickAndMortyEndpoint(rawValue: endpointString) {
                    self.init(
                        endpoint: rickAndMortyEndpoint,
                        queryParameters: queryItems
                    )
                    
                    return
                }
            }
        }
        
        return nil
    }
}

extension RickAndMortyRequest {
    static let listOfCharactersRequest = RickAndMortyRequest(endpoint: .character)
}
