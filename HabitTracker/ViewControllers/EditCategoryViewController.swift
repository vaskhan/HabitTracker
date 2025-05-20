//
//  EditCategoryViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 18.05.2025.
//

import UIKit

final class EditCategoryViewController: UIViewController {
    
    var onCategoryRenamed: ((String) -> Void)?
    private let category: TrackerCategoryCoreData

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.editCategory
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textColor = .blackDay
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = L10n.categoryCreatePlaceholder
        field.textColor = .blackDay
        field.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        field.layer.cornerRadius = 16
        field.setLeftPaddingPoints(16)
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.doneButton, for: .normal)
        button.setTitleColor(.justWhite, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.backgroundColor = .grayText
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()
 
    init(category: TrackerCategoryCoreData) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupLayout()
        setupActions()
        enableHideKeyboardOnTap()
        nameField.text = category.title
        textFieldChanged()
    }
    
    private func setupLayout() {
        [titleLabel, nameField, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        nameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }
    
    @objc private func textFieldChanged() {
        let isFilled = !(nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        createButton.isEnabled = isFilled
        createButton.backgroundColor = isFilled ? .blackDay : .grayText
        
        let textColorName = isFilled ? "whiteDay" : "justWhite"
        let textColor = UIColor(named: textColorName)
        createButton.setTitleColor(textColor, for: .normal)
    }
    
    @objc private func createTapped() {
        guard let title = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else { return }
        onCategoryRenamed?(title)
        dismiss(animated: true)
    }
}
