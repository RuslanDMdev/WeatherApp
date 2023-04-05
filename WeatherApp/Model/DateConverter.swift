//
//  DateConverter.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 03.04.2023.
//

import Foundation

struct DateConverter {
    
    private let timezone: Double
    
    init(timezone: Int) {
        self.timezone = Double(timezone)
    }
    
    func convertDateFromUTC(string: String) -> Date {
        let utcDate = convertDate(from: string)
        return utcDate.addingTimeInterval(self.timezone)
    }
    
    func convertDateFromUTC(string: Int) -> Date {
        let utcDate = convertDate(from: String(string))
        return utcDate.addingTimeInterval(self.timezone)
    }
    
    private func convertDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string) ?? Date()
    }
    
    func compareTime(now: Date, timeZone: Int) -> Bool {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let eightToday = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!

        let fourThirtyToday = calendar.date(bySettingHour: 16, minute: 30, second: 0, of: now)!
        
        if now >= eightToday &&
        now <= fourThirtyToday
        {
         return true
        }
      return false
    }
}

