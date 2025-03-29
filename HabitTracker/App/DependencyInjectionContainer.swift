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
        trackerVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackertLogoTabBar"), tag: 0)

        let statsVC = makeStatisticScreenController()
        statsVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statisticLogoTabBar"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: trackerVC),
            UINavigationController(rootViewController: statsVC)
        ]
        return tabBarController
    }
}
