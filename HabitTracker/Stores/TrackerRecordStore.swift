//
//  TrackerRecordStore.swift
//  HabitTracker
//
//  Created by Василий Ханин on 16.04.2025.
//

import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addRecord(_ record: TrackerRecord) {
        let entity = TrackerRecordCoreData(context: context)
        entity.trackerId = record.trackerId
        entity.date = Calendar.current.startOfDay(for: record.date)
        saveContext()
    }

    func removeRecord(_ record: TrackerRecord) {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let start = Calendar.current.startOfDay(for: record.date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "trackerId == %@", record.trackerId as CVarArg),
            NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
        ])

        do {
            let records = try context.fetch(request)
            records.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Ошибка при удалении записи трекера: \(error)")
        }
    }

    func isCompleted(trackerId: UUID, on date: Date) -> Bool {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "trackerId == %@", trackerId as CVarArg),
            NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
        ])

        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }

    func numberOfCompletions(trackerId: UUID) -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)
        return (try? context.count(for: request)) ?? 0
    }

    func fetchAllRecords() -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()

        do {
            return try context.fetch(request).compactMap {
                guard let id = $0.trackerId, let date = $0.date else { return nil }
                return TrackerRecord(trackerId: id, date: date)
            }
        } catch {
            print("Ошибка при получении всех записей: \(error)")
            return []
        }
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения контекста записей: \(error)")
        }
    }
}
