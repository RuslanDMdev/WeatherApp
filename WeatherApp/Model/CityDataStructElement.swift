//
//  CityDataStructElement.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 29.03.2023.
//

import Foundation

// MARK: - CityDataStructElement
struct CityDataStructElement: Codable {
    let name: String
    let localNames: [String: String]?
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

typealias CityDataStruct = [CityDataStructElement]
