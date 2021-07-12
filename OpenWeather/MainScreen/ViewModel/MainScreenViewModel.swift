//
//  MainScreenViewModel.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import Foundation

class MainScreenViewModel {
    
    func loadForecast(for city: City, _ completion: @escaping (Forecast) -> Void) {
        URLLoader.shared.loadForecastData(for: city) { result in
            switch result {
            case .success(let forecast):
                completion(forecast)
            case .failure(let error):
                print("ERROR: On loadForecast - \(error.localizedDescription)")
            }
        }
    }
}
