//
//  DependencyInjectionContainer.swift
//  HabitTracker
//
//  Created by Василий Ханин on 29.03.2025.
//

import UIKit
import CoreData

final class DependencyInjectionContainer {
    
    lazy var persistentContainer: NSPersistentContainer = {
        DaysValueTransformer.register()
        let container = NSPersistentContainer(name: "ModelCoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Ошибка загрузки хранилища: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Stores
    lazy var trackerStore = TrackerStore(context: context)
    lazy var trackerCategoryStore = TrackerCategoryStore(context: context)
    lazy var trackerRecordStore = TrackerRecordStore(context: context)

    // MARK: - ViewModels
    func makeTrackerViewModel() -> TrackerViewModel {
        TrackerViewModel(
            trackerStore: trackerStore,
            categoryStore: trackerCategoryStore,
            recordStore: trackerRecordStore
        )
    }
    
    func makeStatisticViewModel() -> StatisticViewModel {
        return StatisticViewModel()
    }
    
    // MARK: - ViewControllers
    func makeTrackerScreenController() -> UIViewController {
        let trackerViewModel = makeTrackerViewModel()
        let categoryViewModel = TrackerCategoryViewModel(categoryStore: trackerCategoryStore)
        return TrackerScreenController(viewModel: trackerViewModel, categoryViewModel: categoryViewModel)
    }
    
    func makeStatisticScreenController() -> UIViewController {
        let viewModel = makeStatisticViewModel()
        return StatisticScreenController(viewModel: viewModel)
    }
    
    // MARK: - TabBarController
    func makeTabBarController() -> UITabBarController {
        let trackerVC = makeTrackerScreenController()
        let trackerNav = UINavigationController(rootViewController: trackerVC)
        trackerNav.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackertLogoTabBar"), tag: 0)
        
        let statsVC = makeStatisticScreenController()
        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statisticLogoTabBar"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackerNav, statsNav]
        
        let topLine = UIView()
        topLine.backgroundColor = UIColor.grayText
        topLine.translatesAutoresizingMaskIntoConstraints = false
        tabBarController.tabBar.addSubview(topLine)
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: tabBarController.tabBar.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: tabBarController.tabBar.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        return tabBarController
    }
}
