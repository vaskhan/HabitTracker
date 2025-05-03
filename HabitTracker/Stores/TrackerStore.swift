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
        
        let grouped = Dictionary(grouping: coreDataObjects) { $0.category?.title ?? "Без категории" }
        
        return grouped.compactMap { title, trackerCores in
            let trackers: [Tracker] = trackerCores.compactMap { core in
                guard
                    let id = core.id,
                    let name = core.name,
                    let emoji = core.emoji,
                    let colorHex = core.color
                else {
                    print("Ошибка маппинга трекера: \(core)")
                    return nil
                }
                
                let schedule = core.schedule as? [DayOfWeek] ?? []
                
                return Tracker(
                    id: id,
                    name: name,
                    color: UIColor(hex: colorHex),
                    emoji: emoji,
                    schedule: schedule
                )
            }
            
            return trackers.isEmpty ? nil : TrackerCategory(title: title, trackers: trackers)
        }
    }
    
    func addTracker(id: UUID, name: String, emoji: String, colorHex: String, schedule: [DayOfWeek], category: TrackerCategoryCoreData) {
        let tracker = TrackerCoreData(context: context)
        tracker.id = id
        tracker.name = name
        tracker.emoji = emoji
        tracker.color = colorHex
        tracker.schedule = schedule as NSObject
        tracker.category = category
        saveContext()
    }
    
    func updateTracker(_ tracker: TrackerCoreData, name: String, emoji: String, colorHex: String) {
        tracker.name = name
        tracker.emoji = emoji
        tracker.color = colorHex
        saveContext()
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
