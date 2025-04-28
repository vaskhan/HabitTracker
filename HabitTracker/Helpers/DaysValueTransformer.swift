//
//  DaysValueTransformer.swift
//  HabitTracker
//
//  Created by Василий Ханин on 20.04.2025.
//

import Foundation

@objc
final class DaysValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [DayOfWeek] else { return nil }

        do {
            return try JSONEncoder().encode(days)
        } catch {
            print("❗️Ошибка при преобразовании [DayOfWeek] в Data: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([DayOfWeek].self, from: data as Data)
    }

    static func register() {
        let transformer = DaysValueTransformer()
        let name = NSValueTransformerName(String(describing: DaysValueTransformer.self))
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
