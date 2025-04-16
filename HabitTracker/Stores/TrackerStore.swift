//
//  TrackerStore.swift
//  HabitTracker
//
//  Created by Василий Ханин on 16.04.2025.
//

import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
