//
//  UIViewController+Extensions.swift
//  HabitTracker
//
//  Created by Василий Ханин on 07.04.2025.
//

import UIKit

extension UIViewController {
    func presentSheet(_ viewController: UIViewController) {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.modalPresentationStyle = .pageSheet
        self.present(navigation, animated: true)
    }
    
    func dismissToRoot(animated: Bool = true) {
        var root = self
        while let presenter = root.presentingViewController {
            root = presenter
        }
        root.dismiss(animated: animated)
    }
}
