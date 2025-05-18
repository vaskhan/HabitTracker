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
        case .all: return "Все трекеры"
        case .today: return "Трекеры на сегодня"
        case .completed: return "Завершенные"
        case .uncompleted: return "Не завершенные"
        }
    }
}
