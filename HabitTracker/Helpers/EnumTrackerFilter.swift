//
//  EnumTrackerFilter.swift
//  HabitTracker
//
//  Created by Василий Ханин on 18.05.2025.
//


enum EnumTrackerFilter: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted

    var title: String {
        switch self {
        case .all: return L10n.allTrackers
        case .today: return L10n.trackersToday
        case .completed: return L10n.completed
        case .uncompleted: return L10n.uncompleted
        }
    }
}
