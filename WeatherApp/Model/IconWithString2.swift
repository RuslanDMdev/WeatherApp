//
//  IconWithString2.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 03.04.2023.
//


import Foundation
import UIKit

struct IconWithString2 {
    
   private let timezone: Int
   private let date: Int
    
    init(timezone: Int, date: Int) {
        self.timezone = timezone
        self.date = date
    }
    
    
    func getIcon(with id: Int) -> String {
        
        let dateConverter = DateConverter(timezone: timezone)
        let convertedDate = dateConverter.convertDateFromUTC(string: date)
        
        let isDay = dateConverter.compareTime(now: convertedDate, timeZone: timezone)
        
        switch id {
        case 200...232:
            return "13.thunderstorm-light"
        case 300...321:
            return "18.heavy-rain-light"
        case 500...504:
            return isDay ? "20.rain-light" : "06.rainyday-light"
        case 511...531:
            return "18.heavy-rain-light"
        case 600...622:
            return "14.heavy-snowfall-light"
        case 700...781:
            return isDay ? "15.cloud-light" : "17.cloudy-night-stars-light"
        case 800:
            return isDay ? "01.sun-light" : "19.moon-set-light"
        case 801:
            return isDay ? "05.partial-cloudy-light" : "17.cloudy-night-stars-light"
        case 802:
            return isDay ? "15.cloud-light" : "17.cloudy-night-stars-light"
        case 803...804:
            return isDay ? "11.mostly-cloudy-light" : "16.cloudy-night-light"
            
        default:
            return "nosign"
        }
    }
}
