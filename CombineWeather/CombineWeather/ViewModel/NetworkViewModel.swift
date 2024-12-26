//
//  NetworkViewModel.swift
//  CombineWeather
//
//  Created by Dongik Song on 12/24/24.
//

import Foundation
import Combine

class NetworkViewModel: ObservableObject {
    
    @Published var currentWeather: WeatherModel
//    @Published var forecaseWeather: WeatherModel?
    
    let networkManager: NetworkManager
    var cancellables = Set<AnyCancellable>()
    
    init(currentWeather: WeatherModel, networkManager: NetworkManager) {
        self.currentWeather = currentWeather
        self.networkManager = networkManager
    }
    
    //    func fetchWeather(city: String) {
    //
    //        guard let currentURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=2a34cad3c7caa702942a0aea90a3e703") else { return }
    //        guard let forecastURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=2a34cad3c7caa702942a0aea90a3e703") else { return }
    //
    //        Publishers.CombineLatest(networkManager.fetchRequest(url: currentURL, for: city), networkManager.fetchRequest(url: forecastURL, for: city))
    //            .sink { completion in
    //                switch completion {
    //                case .finished:
    //                    return
    //                case .failure(let error):
    //                    print(error)
    //                }
    //            } receiveValue: { [weak self] current, forecast in
    //                self?.currentWeather = current
    //                self?.forecaseWeather = forecast
    //            }.store(in: &cancellables)
    //
    //    }
    
    func fetchWeather(city: String) {
        
        guard let currentURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(Secret.secretKey)") else { return }
        
        networkManager.fetchRequest(url: currentURL, for: city)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] current in
                self?.currentWeather = current
                print(current)
            }.store(in: &cancellables)
    }
    
}
