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
    let citiesCodes = [City.telAviv, City.jerusalem, City.haifa, City.eilat]

    func loadForecasts(_ completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        URLLoader.shared.loadForecastData() { [weak self] result in
            switch result {
            case .success(let forecastsInRegion):
                guard let strongSelf = self else { return }
                strongSelf.extractCities(forecastsInRegion)
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    fileprivate func extractCities(_ forecastsInRegion: [ForecastCity]) {
        //
        // Put codes in hashMap for faster extraction O(n):
        //
        // We will lookup each forecast in this hashMap rather
        // than lookup each city code in all forecastsInRegion array each
        // time. This way the forecastsInRegion array is enumerated only once.
        //
        // *Remark1: All values in this hashMap will be an arbitrary "1" since
        // we don't care for value. The O(1) retrieval is what's important.
        //
        // *Remark2: At the end of each iteration, we check if we have covered all keys.
        // If this is the case, we're done and therefore don't need to continue
        // searching in forecastsInRegion array any more. Could save iterations.
        //
        // *Remark2: Why not use Set? It's O(logn) retrieval and hashMap is O(1)
        // besides, we don't need ordered data structure here.
        //

        var codesHashMap = [Int: Int]()
        for code in citiesCodes {
            codesHashMap[code.rawValue] = 1 // arbitrary
        }
        
        // Traverse the forecasts array once
        for forecast in forecastsInRegion {
            guard let _ = codesHashMap[forecast.id] else {
                continue
            }
            self.forecasts.append(forecast)
            codesHashMap.removeValue(forKey: forecast.id)
            if codesHashMap.isEmpty {
                break
            }
        }
    }
}
