//
//  HabitTrackerTests.swift
//  HabitTrackerTests
//
//  Created by Василий Ханин on 11.05.2025.
//

import XCTest
import SnapshotTesting
import Testing
@testable import HabitTracker

final class TrackerScreenSnapshotTests: XCTestCase {
    
    func testTrackerScreenForLightAndDarkMode() {
        let container = DependencyInjectionContainer()
        let vc = container.makeTrackerScreenController()
        let nav = UINavigationController(rootViewController: vc)
        
        if let trackerVC = vc as? TrackerScreenController {
            trackerVC.viewModel.loadTrackers()
        }
        
        assertSnapshot(of: nav, as: .image(on: .iPhone13ProMax(.portrait), traits: UITraitCollection(userInterfaceStyle: .dark)))
        assertSnapshot(of: nav, as: .image(on: .iPhone13ProMax(.portrait), traits: UITraitCollection(userInterfaceStyle: .light)))
    }
    
}


