//
//  TrackerStore.swift
//  HabitTracker
//
//  Created by Василий Ханин on 16.04.2025.
//

import CoreData
import UIKit

final class TrackerStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchTrackersGroupedByCategory() -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let coreDataObjects = (try? context.fetch(request)) ?? []
        
        let pinnedTrackers: [Tracker] = coreDataObjects
            .filter { $0.isPinned }
            .compactMap { core in
                guard
                    let id = core.id,
                    let name = core.name,
                    let emoji = core.emoji,
                    let colorHex = core.color
                else { return nil }
                let schedule = core.schedule as? [DayOfWeek] ?? []
                return Tracker(
                    id: id,
                    name: name,
                    color: UIColor(hex: colorHex),
                    emoji: emoji,
                    schedule: schedule,
                    isPinned: true
                )
            }
        
        var result: [TrackerCategory] = []
        if !pinnedTrackers.isEmpty {
            result.append(TrackerCategory(title: "Закреплённые", trackers: pinnedTrackers))
        }
        
        let grouped = Dictionary(grouping: coreDataObjects.filter { !$0.isPinned }) { $0.category?.title ?? "Без категории" }
        
        let sortedCategoryTitles = grouped.keys.sorted { $0.localizedCompare($1) == .orderedAscending }
        
        for title in sortedCategoryTitles {
            guard let trackersCore: [TrackerCoreData] = grouped[title] else { continue }
            let trackers: [Tracker] = trackersCore.compactMap { core in
                guard
                    let id = core.id,
                    let name = core.name,
                    let emoji = core.emoji,
                    let colorHex = core.color
                else { return nil }
                let schedule = core.schedule as? [DayOfWeek] ?? []
                return Tracker(
                    id: id,
                    name: name,
                    color: UIColor(hex: colorHex),
                    emoji: emoji,
                    schedule: schedule,
                    isPinned: false
                )
            }
            if !trackers.isEmpty {
                result.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
        return result
    }
    
    
    func addTracker(id: UUID, name: String, emoji: String, colorHex: String, schedule: [DayOfWeek], category: TrackerCategoryCoreData) {
        let tracker = TrackerCoreData(context: context)
        tracker.id = id
        tracker.name = name
        tracker.emoji = emoji
        tracker.color = colorHex
        tracker.schedule = schedule as NSObject
        tracker.category = category
        tracker.isPinned = false
        saveContext()
    }
    
    func updatePinState(for id: UUID, isPinned: Bool) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let tracker = try? context.fetch(request).first {
            tracker.isPinned = isPinned
            saveContext()
        }
    }
    
    func deleteTracker(for id: UUID) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let tracker = try? context.fetch(request).first {
            context.delete(tracker)
            saveContext()
        }
    }
    
    func updateTracker(_ tracker: Tracker, newCategory: TrackerCategoryCoreData?) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)

        if let existing = try? context.fetch(request).first {
            existing.name = tracker.name
            existing.emoji = tracker.emoji
            existing.color = tracker.color.toHexString()
            existing.schedule = tracker.schedule as NSObject
            existing.isPinned = tracker.isPinned
            
            if let newCategory = newCategory {
                existing.category = newCategory
            }

            saveContext()
        }
    }

    
    func trackerExists(withId id: UUID) -> Bool {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return (try? context.count(for: request)) ?? 0 > 0
    }

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения контекста: \(error)")
        }
    }
}
