//
//  MainScreenViewModel.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import Foundation
import Network
import CoreData
import UIKit

class MainScreenViewModel {
    
    var isGridLayout = true
    var pics = ["ta", "jr", "hf", "et"]
    let listFlowLayout = ListFlowLayout()
    let gridFlowLayout = GridFlowLayout()
    var forecasts = [ForecastPersist]()
    let citiesCodes = [City.telAviv, City.jerusalem, City.haifa, City.eilat]
    let internetMonitor = NWPathMonitor()
    let internetQueue = DispatchQueue(label: "InternetMonitor")
    private var hasConnectionPath = false


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
        var codesHashMap = [Int: Int]()
        for code in citiesCodes {
            codesHashMap[code.rawValue] = 1 // arbitrary
        }
        
        // Traverse the forecasts array once
        var cityForecastArr = [ForecastCity]()
        for forecast in forecastsInRegion {
            guard let _ = codesHashMap[forecast.id] else {
                continue
            }
            cityForecastArr.append(forecast)
            codesHashMap.removeValue(forKey: forecast.id)
            if codesHashMap.isEmpty {
                break
            }
        }
        
        DispatchQueue.main.sync {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            for city in cityForecastArr {

                let forecast = ForecastPersist(context: context)

                forecast.cityName = city.name
                forecast.feelsLike = city.main.feelsLike
                if let humidity = city.main.humidity {
                    forecast.humidity = Int32(humidity)
                }
                if let pressure = city.main.pressure {
                    forecast.pressure = Int32(pressure)
                }
                if let seaLevel = city.main.seaLevel {
                    forecast.seaLevel = Int32(seaLevel)
                }
                forecast.temperature = city.main.temp
                forecast.weatherDescription = city.weather[0].weatherDescription
                forecast.windDirection = Int32(city.wind.deg)
                forecast.windSpeed  = city.wind.speed
                
                self.forecasts.append(forecast)
            }
        }
    }
}
