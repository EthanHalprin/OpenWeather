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
    
    /// Initiate a region call to fetch all 4 cities - Israel's rect for that is:
    ///
    ///  33.05506, 34.54736---------------32.92478, 35.49168
    ///       |                                    |
    ///       |                                    |
    ///       |                                    |
    /// 29.50932, 34.22430----------------29.471465, 35.249387
    ///
    /// - Parameter completionHandler: completion returning Israel's cities forecasts only
    func loadForecastData(_ completionHandler: @escaping (Result<[ForecastCity], Error>) -> Void ) {
        
        guard let key = self.apiKey else {
            completionHandler(.failure(NetworkError.emptyData))
            return
        }

        // [lon-left,lat-bottom,lon-right,lat-top]
        var request = URLRequest(url: URL(string: #"https://api.openweathermap.org/data/2.5/box/city?bbox=34.54736,29.50932,35.49168,33.05506,100&APPID=\#(key)"#)!,
                                 timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
            guard forecastRegion.list.count > 0 else {
                completionHandler(.failure(NetworkError.noCitiesInRegion))
                return
            }
            completionHandler(.success(forecastRegion.list))
        }

        task.resume()
    }
}
