//
//  AppDelegate.swift
//  HabitTracker
//
//  Created by Василий Ханин on 25.03.2025.
//

import UIKit
import YandexMobileMetrica

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let configuration = YMMYandexMetricaConfiguration(apiKey: Constants.metricaAPIKey) {
            YMMYandexMetrica.activate(with: configuration)
        } else {
            print("Не удалось создать конфигурацию Яндекс.Метрики")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

private enum Constants {
    static let metricaAPIKey = "3b3fd7e9-c2d3-453b-ba5e-71c0f66f3b1d"
}
