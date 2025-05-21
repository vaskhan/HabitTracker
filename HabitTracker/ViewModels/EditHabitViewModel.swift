//
//  EditHabitViewModel.swift
//  HabitTracker
//
//  Created by Василий Ханин on 17.05.2025.
//

import UIKit

final class EditHabitViewModel {
    let tracker: Tracker
    let completedDays: Int

    var name: String
    var selectedCategory: TrackerCategory
    var selectedSchedule: [DayOfWeek]
    var selectedEmoji: String
    var selectedColor: UIColor

    init(tracker: Tracker, completedDays: Int, category: TrackerCategory) {
        self.tracker = tracker
        self.completedDays = completedDays
        self.name = tracker.name
        self.selectedCategory = category
        self.selectedSchedule = tracker.schedule
        self.selectedEmoji = tracker.emoji
        self.selectedColor = tracker.color
    }

    func updateTracker() -> Tracker {
        return Tracker(
            id: tracker.id,
            name: name,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: selectedSchedule,
            isPinned: tracker.isPinned
        )
    }
}
