//
//  URLLoader.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import Foundation

struct URLLoader {
    static let shared = URLLoader()
    var apiKey: String!

    private init() {
        if let key = UserDefaults.standard.string(forKey: "OW_API_Key") {
            self.apiKey = key
        }
    }
    
    /*
     api.openweathermap.org/data/2.5/box/city?bbox=34.54736,29.50932,35.49168,33.05506,100&APPID=298b60e02f2991627d6b5a431f7c31f1
     */

    func loadForecastData(_ completionHandler: @escaping (Result<[ForecastCity], Error>) -> Void ) {
        
        guard let key = self.apiKey else {
            completionHandler(.failure(NetworkError.emptyData))
            return
        }
        var request = URLRequest(url: URL(string: #"https://api.openweathermap.org/data/2.5/box/city?bbox=34.54736,29.50932,35.49168,33.05506,100&APPID=\#(key)"#)!,
                                 timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("\n\n===============================================================")
            
            guard error == nil else {
                completionHandler(.failure(error!))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NetworkError.emptyData))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)!
            let jsonData = jsonString.data(using: .utf8)!
            let forecastRegion = try! JSONDecoder().decode(ForecastRegion.self, from: jsonData)
            print("\(forecastRegion)")
            guard forecastRegion.list.count > 0 else {
                completionHandler(.failure(NetworkError.noCitiesInRegion))
                return
            }
            completionHandler(.success(forecastRegion.list))

            print("===============================================================\n\n")
        }

        task.resume()
    }
}
