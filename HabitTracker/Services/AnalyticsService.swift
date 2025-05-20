//
//  AnalyticsService.swift
//  HabitTracker
//
//  Created by Василий Ханин on 20.05.2025.
//


import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    func sendEvent(event: String, screen: String, item: String? = nil) {
        var params: [String: Any] = ["event": event,"screen": screen]

        if let item = item {
            params["item"] = item
        }

        YMMYandexMetrica.reportEvent("user_event", parameters: params, onFailure: { error in
        })
    }
}
