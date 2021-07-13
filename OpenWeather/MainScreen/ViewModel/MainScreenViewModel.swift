//
//  MainScreenViewModel.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import Foundation

class MainScreenViewModel {
    
    var isGridLayout = true
    var temps = [33, 23, 21, 40]
    var pics = ["ta", "jr", "hf", "et"]
    let listFlowLayout = ListFlowLayout()
    let gridFlowLayout = GridFlowLayout()
    var forecasts = [ForecastCity]()
    
    func loadForecasts(_ completion: @escaping ([ForecastCity]) -> Void) {
        URLLoader.shared.loadForecastData() { result in
            switch result {
            case .success(let forecasts):
                completion(forecasts)
            case .failure(let error):
                print("ERROR: On loadForecast - \(error.localizedDescription)")
            }
        }
    }
}
