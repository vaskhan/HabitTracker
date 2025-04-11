//
//  Tracker.swift
//  HabitTracker
//
//  Created by Василий Ханин on 01.04.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [DayOfWeek]
}

