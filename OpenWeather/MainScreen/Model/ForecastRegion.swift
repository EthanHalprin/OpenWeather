//
//  ForecastRegion.swift
//  OpenWeather
//
//  Created by Ethan on 13/07/2021.
//
//   let forecastCity = try? newJSONDecoder().decode(ForecastCity.self, from: jsonData)
//
import Foundation

// MARK: - ForecastRegion
struct ForecastRegion: Codable {
    let cod: Int
    let calctime: Double
    let cnt: Int
    let list: [ForecastCity]
}
