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
    
    func enableHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}

extension UIView {
    func findTextField() -> UITextField? {
        if let textField = self as? UITextField {
            return textField
        }
        for subview in subviews {
            if let found = subview.findTextField() {
                return found
            }
        }
        return nil
    }
}
