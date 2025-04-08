//
//  CreateTrackerViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 04.04.2025.
//
import UIKit

final class CreateEventViewController: UIViewController {
    var onCreateTracker: ((TrackerCategory) -> Void)?
    
    private var selectedCategory: TrackerCategory? = TrackerCategory(title: "Домашний уют", trackers: []) {
        didSet {
            updateCategoryUI()
            updateCreateButtonState()
        }
    }
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новое нерегулярное событие"
        label.textColor = .blackDay
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.textColor = .grayText
        field.font = UIFont(name: "SFPro-Regular", size: 17)
        field.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        field.layer.cornerRadius = 16
        field.setLeftPaddingPoints(16)
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private let categoryButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleButtonLabel = UILabel()
        titleButtonLabel.text = "Категория"
        titleButtonLabel.textColor = .blackDay
        titleButtonLabel.font = UIFont(name: "SFPro-Regular", size: 17)
        
        let subtitButtonleLabel = UILabel()
        subtitButtonleLabel.text = ""
        subtitButtonleLabel.textColor = .grayText
        subtitButtonleLabel.font = UIFont(name: "SFPro-Regular", size: 17)
        
        let chevronImageView = UIImageView(image: UIImage(named: "chevronForField"))
        
        [titleButtonLabel, subtitButtonleLabel, chevronImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleButtonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleButtonLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            
            subtitButtonleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitButtonleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -14),
            
            chevronImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.redYPcolor, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.redYPcolor.cgColor
        button.layer.cornerRadius = 16
        button.backgroundColor = .clear
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.layer.cornerRadius = 16
        button.backgroundColor = .grayText
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateCategoryUI()
        updateCreateButtonState()
        nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        enableHideKeyboardOnTap()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        [titleLabel, nameField, categoryButtonView, cancelButton, createButton].forEach {
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
            
            categoryButtonView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            categoryButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryButtonView.heightAnchor.constraint(equalToConstant: 75),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        categoryButtonView.addGestureRecognizer(tapGesture)
    }
    
    private func updateCategoryUI() {
        if let subtitleLabel = categoryButtonView.subviews.compactMap({ $0 as? UILabel }).last {
            subtitleLabel.text = selectedCategory?.title ?? ""
        }
    }
    
    @objc private func categoryTapped() {
        print("Выбор категории")
    }
    
    private func updateCreateButtonState() {
        let nameFilled = !(nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let categoryChosen = selectedCategory != nil
        createButton.isEnabled = nameFilled && categoryChosen
        createButton.backgroundColor = createButton.isEnabled ? .blackDay : .gray
    }
    
    @objc private func textFieldDidChange() {
        updateCreateButtonState()
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        guard let selectedCategory = selectedCategory else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            name: nameField.text ?? "",
            color: .systemTeal,
            emoji: "🛋️",
            schedule: []
        )
        
        let newCategory = TrackerCategory(
            title: selectedCategory.title,
            trackers: selectedCategory.trackers + [newTracker]
        )
        
        onCreateTracker?(newCategory)
        dismissToRoot()
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


