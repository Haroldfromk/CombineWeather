//
//  CoreLocationManager.swift
//  CombineWeather
//
//  Created by Dongik Song on 12/26/24.
//

import Foundation
import CoreLocation

class CoreLocationManager: NSObject, ObservableObject {
    
    private var locationManager: CLLocationManager?
    
    @Published var location: CLLocation?
    @Published var area: String?
    
    init(locationManager: CLLocationManager) {
        super.init()
        self.locationManager = locationManager
        locationManager.delegate = self
    }
    
    func request() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func convertCoordinateToAddress() {
        if let location {
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "en_US") // 영어로 출력되도록 설정
            
            geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?.first
                    self?.area = firstLocation?.administrativeArea // 부산광역시x busan
                } else {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
            }
        }
    }
}

extension CoreLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager?.startUpdatingLocation()
    }
}
