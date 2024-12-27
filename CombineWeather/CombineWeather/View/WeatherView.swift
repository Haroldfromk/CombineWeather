//
//  WeatherView.swift
//  CombineWeather
//
//  Created by Dongik Song on 12/24/24.
//

import SwiftUI
import Combine
import CoreLocation

struct WeatherView: View {
    
    @EnvironmentObject private var networkViewModel: NetworkViewModel
    @EnvironmentObject var coreLocationManager: CoreLocationManager
    
    @State private var cancellables = Set<AnyCancellable>()
    @State var imageName = ""
    
    var body: some View {
        ZStack {
            BackgroundImageView(name: imageName)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                
                HStack {
                    Text("\(String(describing: coreLocationManager.area ?? "Loading"))")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text(Date().formatted(.dateTime.day().month().year()))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                HStack {
                    VStack(spacing: 15) {
                        Text("\(Decimal(networkViewModel.currentWeather.main.temp).convert)°c")
                            .font(.system(size: 80))
                            .foregroundStyle(.white)
                        
                        Text("Feel: \(Decimal(networkViewModel.currentWeather.main.feelsLike).convert)°c")
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                        
                        HStack {
                            Text("Min: \(Decimal(networkViewModel.currentWeather.main.tempMin).convert)°c")
                                .font(.system(size: 25))
                                .foregroundStyle(.white)
                            
                            
                            Text("Max: \(Decimal(networkViewModel.currentWeather.main.tempMax).convert)°c")
                                .font(.system(size: 25))
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                Spacer()
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    
                }
                
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            coreLocationManager.request()
        }
        .onReceive(coreLocationManager.$location) { _ in
            coreLocationManager.convertCoordinateToAddress()
            networkViewModel.fetchWeather(city: coreLocationManager.area ?? "paris")
            getCondition()
        }
    }
    
    func getCondition() {
        networkViewModel.$currentWeather
            .map(\.weather)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { weather in
                if let id = weather.first?.id {
                    print(id)
                    switch id {
                    case 200...232 : imageName = "thunderstrom"
                    case 300...321 : imageName = "drizzle"
                    case 500...531 : imageName = "rain"
                    case 600...622 : imageName = "snow"
                    case 700...781 : imageName = "foggy"
                    case 800 : imageName = "sunny"
                    case 801...804 : imageName = "cloud"
                    default : imageName = "sunny"
                    }
                } else {
                    imageName = "sunny"
                }
                
            })
            .store(in: &cancellables)
    }
 
    
}


#Preview {
    WeatherView()
}
