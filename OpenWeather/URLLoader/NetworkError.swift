//
//  NetworkError.swift
//  OpenWeather
//
//  Created by Ethan on 12/07/2021.
//

import Foundation

enum NetworkError: Error {
    case keyBadOrMissing
    case badURL
    case emptyData
    case noCitiesInRegion
}
