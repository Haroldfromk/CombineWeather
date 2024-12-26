//
//  NetworkManager.swift
//  CombineWeather
//
//  Created by Dongik Song on 12/24/24.
//

import Foundation
import Observation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}

@Observable
class NetworkManager {
    
    func fetchRequest(url: URL, for city: String) -> AnyPublisher<WeatherModel, NetworkError> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                return data
            })
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .mapError({ error in
                return NetworkError.invalidURL
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}
