//
//  RickAndMortyService.swift
//  RickAndMortyiOSApp
//
//  Created by Nikos Aggelidis on 19/2/23.
//

import Foundation

final class RickAndMortyService {
    static let shared = RickAndMortyService()
    
    private init() {}
    
    enum RickAndMortyError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    public func execute<T: Codable>(
        _ rickAndMortyRequest: RickAndMortyRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = request(from: rickAndMortyRequest) else { completion(.failure(RickAndMortyError.failedToCreateRequest))
            
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RickAndMortyError.failedToGetData))
                
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func request(from rickAndMortyRequest: RickAndMortyRequest) -> URLRequest? {
        guard let url = rickAndMortyRequest.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = rickAndMortyRequest.httpMethod
        
        return urlRequest
    }
}
