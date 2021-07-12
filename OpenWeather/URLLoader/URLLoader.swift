//
//  URLLoader.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum City: Int {
    case jerusalem = 123
    case telAviv = 293397
    case haifa = 323
    case eilat = 3432
}

class URLLoader {
    
    func loadForecast(for city: City) {
        //let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: #"https://api.openweathermap.org/data/2.5/weather?id=\#(String(city.rawValue))&APPID=298b60e02f2991627d6b5a431f7c31f1"#)!,
                                 timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("\n\n===============================================================")
            guard let data = data else {
                print(String(describing: error))
                //semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            print("===============================================================\n\n")
            //semaphore.signal()
        }

        task.resume()
        //semaphore.wait()
    }
}
