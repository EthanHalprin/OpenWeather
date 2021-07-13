//
//  Forecast.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//
//   let forecastCity = try? newJSONDecoder().decode(ForecastCity.self, from: jsonData)
//
import Foundation

// MARK: - ForecastCity
struct ForecastCity: Codable {
    let id, dt: Int
    let name: String
    let coord: Coord
    let main: Main
    let visibility: Int
    let wind: Wind
    //"rain": {
    //  "1h": 0.15
    //},
    let rain, snow: [String: Double]?
    let clouds: Clouds
    let weather: [Weather]
}

// MARK: - Clouds
struct Clouds: Codable {
    let today: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double

    enum CodingKeys: String, CodingKey {
        case lon = "Lon"
        case lat = "Lat"
    }
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
