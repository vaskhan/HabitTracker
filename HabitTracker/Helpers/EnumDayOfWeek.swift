//
//  DayOfWeek.swift
//  HabitTracker
//
//  Created by Василий Ханин on 01.04.2025.
//
import Foundation

enum DayOfWeek: Int, CaseIterable, Codable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

extension DayOfWeek {
    var shortNameDay: String {
        switch self {
        case .monday: return L10n.mondayShort
        case .tuesday: return L10n.tuesdayShort
        case .wednesday: return L10n.wednesdayShort
        case .thursday: return L10n.thursdayShort
        case .friday: return L10n.fridayShort
        case .saturday: return L10n.saturdayShort
        case .sunday: return L10n.sundayShort
        }
    }

    var fullNameDay: String {
        switch self {
        case .monday: return L10n.mondayFull
        case .tuesday: return L10n.tuesdayFull
        case .wednesday: return L10n.wednesdayFull
        case .thursday: return L10n.thursdayFull
        case .friday: return L10n.fridayFull
        case .saturday: return L10n.saturdayFull
        case .sunday: return L10n.sundayFull
        }
    }
}

extension DayOfWeek {
    static func fromSystemWeekday(_ systemWeekday: Int) -> DayOfWeek? {
        let shifted = (systemWeekday + 5) % 7 + 1
        return DayOfWeek(rawValue: shifted)
    }
}
