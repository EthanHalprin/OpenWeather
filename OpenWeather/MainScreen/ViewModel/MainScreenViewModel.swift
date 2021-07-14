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


enum LoadingType {
    case database
    case network
}

class MainScreenViewModel {
    
    var isGridLayout = true
    var pics = ["ta", "jr", "hf", "et"]
    let listFlowLayout = ListFlowLayout()
    let gridFlowLayout = GridFlowLayout()
    var forecasts = [NSManagedObject]()  // ForecastPersist is a NSManagedObject deriviative
    let citiesCodes = [City.telAviv, City.jerusalem, City.haifa, City.eilat]
    let internetMonitor = NWPathMonitor()
    let internetQueue = DispatchQueue(label: "InternetMonitor")
    private var hasConnectionPath = false

    func loadForecasts(via: LoadingType, _ completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        switch via {
        case .database:
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ForecastPersist")
                do {
                    self.forecasts = try managedContext.fetch(fetchRequest)
                    completionHandler(.success(true))
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                    completionHandler(.failure(error))
                }
            }
        case .network:
            self.forecasts.removeAll()
            URLLoader.shared.loadForecastData() { [weak self] result in
                switch result {
                case .success(let forecastsInRegion):
                    guard let strongSelf = self else { return }
                    strongSelf.storeSubsetCities(in: forecastsInRegion)
                    completionHandler(.success(true))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}

extension MainScreenViewModel {
    
    fileprivate func storeSubsetCities(in forecastsInRegion: [ForecastCity]) {
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
        
        for city in cityForecastArr {
            persist(city)
        }
    }
    
    fileprivate func persist(_ city: ForecastCity) {
        
        var managedViewContext: NSManagedObjectContext?
        
        DispatchQueue.main.sync {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            managedViewContext = appDelegate.persistentContainer.viewContext
        }
        guard let managedContext = managedViewContext else {
            print("Error: Could not create NSManagedObjectContext")
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ForecastPersist")
        fetchRequest.predicate = NSPredicate(format: "cityName = %@" ,city.name)

        var fetchedObject: NSManagedObject?
        
        do {
            let fetchResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            guard let results = fetchResults, results.count == 1 else {
                self.add(city)
                return
            }
            results[0].setValue(city.main.feelsLike, forKey: "feelsLike")
            if let humidity = city.main.humidity {
                results[0].setValue(Int32(humidity), forKey: "humidity")
            }
            if let pressure = city.main.pressure {
                results[0].setValue(Int32(pressure), forKey: "pressure")
            }
            if let seaLevel = city.main.seaLevel {
                results[0].setValue(Int32(seaLevel), forKey: "seaLevel")
            }
            results[0].setValue(city.main.temp, forKey: "temperature")
            results[0].setValue(city.weather[0].weatherDescription, forKey: "weatherDescription")
            results[0].setValue(Int32(city.wind.deg), forKey: "windDirection")
            results[0].setValue(city.wind.speed, forKey: "windSpeed")
            fetchedObject = results[0]
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try managedContext.save()
            if let fetched = fetchedObject {
                forecasts.append(fetched)
            }
//            if let fetched = fetchedObject {
//                var found = false
//                for (i, forecast) in self.forecasts.enumerated() {
//                    if (forecast as! ForecastPersist).cityName == (fetched as! ForecastPersist).cityName {
//                        update(index: i, with: (fetched as! ForecastPersist))
//                        found = true
//                        break
//                    }
//                }
//                if !found {
//                    forecasts.append(fetched)
//                }
//            }
        }
        catch {
            print("Could not save. \(error)")
        }
    }

    fileprivate func update(index: Int, with input: ForecastPersist) {
        (forecasts[index] as! ForecastPersist).feelsLike = input.feelsLike
        (forecasts[index] as! ForecastPersist).humidity = input.humidity
        (forecasts[index] as! ForecastPersist).pressure = input.pressure
        (forecasts[index] as! ForecastPersist).seaLevel = input.seaLevel
        (forecasts[index] as! ForecastPersist).temperature = input.temperature
        (forecasts[index] as! ForecastPersist).weatherDescription = input.weatherDescription
        (forecasts[index] as! ForecastPersist).windDirection = input.windDirection
        (forecasts[index] as! ForecastPersist).windSpeed = input.windSpeed
    }
    
    fileprivate func add(_ city: ForecastCity) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ForecastPersist", in: managedContext)!
        let forecastPersist = NSManagedObject(entity: entity, insertInto: managedContext)

        forecastPersist.setValue(city.name, forKeyPath: "cityName")
        forecastPersist.setValue(city.main.feelsLike, forKeyPath: "feelsLike")
        if let humidity = city.main.humidity {
            forecastPersist.setValue(Int32(humidity), forKeyPath: "humidity")
        }
        if let pressure = city.main.pressure {
            forecastPersist.setValue(Int32(pressure), forKeyPath: "pressure")
        }
        if let seaLevel = city.main.seaLevel {
            forecastPersist.setValue(Int32(seaLevel), forKeyPath: "seaLevel")
        }
        forecastPersist.setValue(city.main.temp, forKeyPath: "temperature")
        forecastPersist.setValue(city.weather[0].weatherDescription, forKeyPath: "weatherDescription")
        forecastPersist.setValue(Int32(city.wind.deg), forKeyPath: "windDirection")
        forecastPersist.setValue(city.wind.speed, forKeyPath: "windSpeed")

        do {
            try managedContext.save()
            self.forecasts.append(forecastPersist)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
