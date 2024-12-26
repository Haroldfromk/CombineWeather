//
//  ContentView.swift
//  CombineWeather
//
//  Created by Dongik Song on 12/22/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject var networkViewModel = NetworkViewModel(
        currentWeather: WeatherModel(weather: [],
                                     main: Main(temp: 0, feelsLike: 0, tempMin: 0, tempMax: 0, pressure: 0, humidity: 0),
                                     wind: Wind(speed: 0, deg: 0),
                                     timezone: 0,
                                     id: 0,
                                     name: "",
                                     cod: 0),
        networkManager: NetworkManager()
    )
    
    @StateObject var coreLocationManager = CoreLocationManager(locationManager: CLLocationManager())
    
    
    var body: some View {
        TabView {
            Tab("Weather", systemImage: "cloud.sun") {
                WeatherView()
                    .environmentObject(networkViewModel)
                    .environmentObject(coreLocationManager)
            }
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
                    .environmentObject(networkViewModel)
            }
        }
        .tint(.white)

    }
    
}

#Preview {
    NavigationView {
        ContentView()
        
    }
}
