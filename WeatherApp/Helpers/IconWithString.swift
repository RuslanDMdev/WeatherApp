//
//  IconWithString.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 11.03.2023.
//

import Foundation
import UIKit

struct IconWithString {
    
    private let date: Int
    
    init(date: Int) {
        self.date = date
    }
    
    func getImageForWeatherCode(_ weatherCode: Int) -> String {
        switch weatherCode {
        case 0:
            return "01.sun-light"
        case 1:
            return "01.sun-light"
        case 2:
            return "05.partial-cloudy-light"
        case 3:
            return "11.mostly-cloudy-light"
        case 45, 48:
            return "11.mostly-cloudy-light"
        case 51, 53, 55:
            return "06.rainyday-light"
        case 56, 57:
            return "14.heavy-snowfall-light"
        case 61, 63, 65:
            return "18.heavy-rain-light"
        case 66, 67:
            return "14.heavy-snowfall-light"
        case 71, 73, 75:
            return "14.heavy-snowfall-light"
        case 77:
            return "14.heavy-snowfall-light"
        case 80...82:
            return "18.heavy-rain-light"
        case 85, 86:
            return "13.thunderstorm-light"
        case 95, 96, 99:
            return "13.thunderstorm-light"
            
        default:
            return "background1"
        }
    }
}
