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

    func loadForecastData(for city: City, _ completionHandler: @escaping (Result<Forecast, Error>) -> Void ) {
        
        guard let key = self.apiKey else {
            completionHandler(.failure(NetworkError.emptyData))
            return
        }
        var request = URLRequest(url: URL(string: #"https://api.openweathermap.org/data/2.5/weather?id=\#(String(city.rawValue))&APPID=\#(key)"#)!,
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
            let forecast = try! JSONDecoder().decode(Forecast.self, from: jsonData)
            print("\(forecast)")
            completionHandler(.success(forecast))
            print("===============================================================\n\n")
        }

        task.resume()
    }
}
