//
//  DecodingTheWeatherString.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 14.03.2023.
//

import Foundation
import UIKit

struct DecodingTheWeatherString {
    
    private let date: Int
    
    init(date: Int) {
        self.date = date
    }
    
    func getTextFromWeatherCode(_ weatherCode: Int) -> String {
        switch weatherCode {
        case 0:
            return "Чистое небо"
        case 1:
            return "Преимущественно ясно"
        case 2:
            return "Частично облачно"
        case 3:
            return "Пасмурно"
        case 45, 48:
            return "Туман"
        case 51, 53, 55:
            return "Дождливо"
        case 56, 57:
            return "Тающий снег"
        case 61, 63, 65:
            return "Дождь"
        case 66, 67:
            return "Снег"
        case 71, 73, 75:
            return "Снег"
        case 77:
            return "Снежные хлопья"
        case 80...82:
            return "Дождь"
        case 85, 86:
            return "Ливень"
        case 95, 96, 99:
            return "Гроза"
            
        default:
            return "nosign"
        }
    }
}
