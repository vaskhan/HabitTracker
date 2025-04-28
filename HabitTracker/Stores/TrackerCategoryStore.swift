//
//  TrackerCategoryStore.swift
//  HabitTracker
//
//  Created by Василий Ханин on 16.04.2025.
//

import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)

        return try? context.fetch(request).first
    }
    
    func createCategoryIfNeeded(title: String) -> TrackerCategoryCoreData {
        if let existing = fetchCategory(with: title) {
            return existing
        }
        
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.title = title
        saveContext()
        return newCategory
    }

    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения контекста категории: \(error)")
        }
    }
}
