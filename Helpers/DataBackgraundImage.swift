//
//  DataBackgraundImage.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 14.03.2023.
//

import Foundation
import UIKit

struct DataBackgraundImage {
    
    private let date: Int
    
    init(date: Int) {
        self.date = date
    }
    
    func getBGImageFromWeatherCode(_ weatherCode: Int) -> String {
        switch weatherCode {
        case 0:
            return "clear-sky"
        case 1:
            return "cloud-clear-sky.png"
        case 2:
            return "cloudy"
        case 3:
            return "hard-cloudy"
        case 51...67:
            return "rain"
        case  71...77:
            return "snow"
        default:
            return "background"
        }
    }
}
