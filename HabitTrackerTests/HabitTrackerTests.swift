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
    
    // MARK: - Setup
    private var container: DependencyInjectionContainer!
    private var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        container = DependencyInjectionContainer()
        let trackerVC = container.makeTrackerScreenController(statisticsCallback: { _ in })
        navigationController = UINavigationController(rootViewController: trackerVC)
       
        _ = navigationController.view
        
        (trackerVC as? TrackerScreenController)?.viewModel.loadTrackers()
    }
    
    // MARK: - Tests
    func test_trackerScreen_lightMode() {
        assertSnapshot(
            of: navigationController,
            as: .image(on: .iPhone13ProMax(.portrait), traits: .init(userInterfaceStyle: .light))
        )
    }
    
    func test_trackerScreen_darkMode() {
        assertSnapshot(
            of: navigationController,
            as: .image(on: .iPhone13ProMax(.portrait), traits: .init(userInterfaceStyle: .dark))
        )
    }
}



