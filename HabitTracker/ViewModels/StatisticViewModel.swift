//
//  StatisticViewModel.swift
//  HabitTracker
//
//  Created by Василий Ханин on 29.03.2025.
//

import Foundation

final class StatisticViewModel {
    
    private let trackers: [Tracker]
    private let records: [TrackerRecord]
    private let allDates: [Date]
    
    init(trackers: [Tracker], records: [TrackerRecord]) {
        self.trackers = trackers
        self.records = records
        self.allDates = Array(Set(records.map { $0.date.stripTime() })).sorted()
    }
    
    var hasStatistics: Bool {
        !records.isEmpty
    }
    
    var completedTrackers: Int {
        Set(records.map { $0.trackerId }).count
    }
    
    var averageValue: Int {
        guard !allDates.isEmpty else { return 0 }
        let grouped = Dictionary(grouping: records, by: { $0.date.stripTime() })
        let total = grouped.values.map(\.count).reduce(0, +)
        return total / allDates.count
    }
    
    var idealDays: Int {
        let grouped = Dictionary(grouping: records, by: { $0.date.stripTime() })
        var count = 0
        
        for (date, recordsForDay) in grouped {
            let dayOfWeek = date.dayOfWeek()
            let activeTrackers = trackers.filter { $0.schedule.contains(dayOfWeek) }
            let completedIds = Set(recordsForDay.map { $0.trackerId })
            
            if activeTrackers.count == completedIds.count && !activeTrackers.isEmpty {
                count += 1
            }
        }
        
        return count
    }
    
    var bestPeriod: Int {
        guard !allDates.isEmpty else { return 0 }
        
        var best = 1
        var current = 1
        
        for i in 1..<allDates.count {
            let prev = allDates[i - 1]
            let curr = allDates[i]
            if Calendar.current.isDate(curr, inSameDayAs: prev.addingDays(1)) {
                current += 1
                best = max(best, current)
            } else {
                current = 1
            }
        }
        
        return best
    }
}

extension Date {
    func stripTime() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func addingDays(_ days: Int) -> Date {
        guard let newDate = Calendar.current.date(byAdding: .day, value: days, to: self) else {
            return self
        }
        return newDate
    }
    
    func dayOfWeek() -> DayOfWeek {
        let weekday = Calendar.current.component(.weekday, from: self)
        return DayOfWeek.fromSystemWeekday(weekday) ?? .monday
    }
}
