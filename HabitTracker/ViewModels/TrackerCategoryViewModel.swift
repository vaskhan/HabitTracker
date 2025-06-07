//
//  TrackerCategoryViewModel.swift
//  HabitTracker
//
//  Created by Василий Ханин on 03.05.2025.
//

import Foundation

final class TrackerCategoryViewModel {
    
    let categoryStore: TrackerCategoryStore

    var onCategoriesUpdated: (([TrackerCategoryCoreData]) -> Void)?

    private(set) var categories: [TrackerCategoryCoreData] = [] {
        didSet {
            onCategoriesUpdated?(categories)
        }
    }

    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        self.categories = categoryStore.fetchAllCategories()

        categoryStore.onCategoriesChanged = { [weak self] updatedCategories in
            self?.categories = updatedCategories
        }
    }

    func loadCategories() {
        categories = categoryStore.fetchAllCategories()
    }

    func addCategory(with title: String) {
        _ = categoryStore.createCategoryIfNeeded(title: title)
    }

    func category(at index: Int) -> TrackerCategoryCoreData {
        categories[index]
    }

    var numberOfCategories: Int {
        categories.count
    }
}
