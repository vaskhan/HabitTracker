//
//  DependencyInjectionContainer.swift
//  HabitTracker
//
//  Created by Василий Ханин on 29.03.2025.
//

import UIKit

final class DependencyInjectionContainer {
    
    // MARK: - ViewModels
    func makeTrackerViewModel() -> TrackerViewModel {
        return TrackerViewModel()
    }
    
    func makeStatisticViewModel() -> StatisticViewModel {
        return StatisticViewModel()
    }
    
    // MARK: - ViewControllers
    func makeTrackerScreenController() -> UIViewController {
        let viewModel = makeTrackerViewModel()
        return TrackerScreenController(viewModel: viewModel)
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
