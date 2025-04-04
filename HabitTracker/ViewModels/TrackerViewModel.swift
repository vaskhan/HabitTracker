//
//  TrackerViewModel.swift
//  HabitTracker
//
//  Created by Василий Ханин on 29.03.2025.
//
import UIKit

final class TrackerViewModel {
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    func numberOfSections() -> Int {
        categories.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        categories[indexPath.section].trackers[indexPath.item]
    }
    
    func titleForSection(_ section: Int) -> String {
        categories[section].title
    }
    
    func toggleTrackerCompletion(trackerID: UUID, on date: Date) {
        let dayStart = Calendar.current.startOfDay(for: date)
        let record = TrackerRecord(trackerId: trackerID, date: dayStart)
        
        if let index = completedTrackers.firstIndex(of: record) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(record)
        }
    }
    
    func completedDays(for trackerID: UUID) -> Int {
        completedTrackers.filter { $0.trackerId == trackerID }.count
    }

    func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool {
        completedTrackers.contains { $0.trackerId == trackerID && Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}
