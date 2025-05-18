//
//  TrackerCategoryStore.swift
//  HabitTracker
//
//  Created by Василий Ханин on 16.04.2025.
//

import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext

    var onCategoriesChanged: (([TrackerCategoryCoreData]) -> Void)?

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let result = (try? context.fetch(request)) ?? []
        return result
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
        return createNewCategory(title: title)
    }

    func createNewCategory(title: String) -> TrackerCategoryCoreData {
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        saveContext()
        notifyObservers()
        return category
    }

    private func notifyObservers() {
        let all = fetchAllCategories()
        onCategoriesChanged?(all)
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения контекста категории: \(error)")
        }
    }
    
    func deleteCategory(_ category: TrackerCategoryCoreData) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)

        if let trackers = try? context.fetch(request) {
            for tracker in trackers {
                context.delete(tracker)
            }
        }

        context.delete(category)
        saveContext()
        notifyObservers()
    }
    
    func renameCategory(_ category: TrackerCategoryCoreData, to newTitle: String) {
        category.title = newTitle
        saveContext()
        notifyObservers()
    }
}
