//
//  TrackerScreenController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 29.03.2025.
//

import UIKit

final class TrackerScreenController: UIViewController {
    
    private let viewModel: TrackerViewModel
    
    // MARK: - UI Elements
    
    private let addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "buttonAddingLogo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.accessibilityIdentifier = "addTracker"
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        return picker
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Трекеры"
        title.font = UIFont(name: "SFPro-Bold", size: 34)
        title.textColor = .blackDay
        return title
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Поиск"
        bar.searchBarStyle = .minimal
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    private let backLogo: UIImageView = {
        let image = UIImage(named: "backLogoTrackerScreen")
        let view = UIImageView(image: image)
        return view
    }()
    
    private let underLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.textColor = .blackDay
        return label
    }()
    
    // MARK: - Stacks
    
    private lazy var topControlsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addTrackerButton, datePicker])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    // MARK: - Init
    
    init(viewModel: TrackerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupElements()
    }
    
    // MARK: - Setup
    
    private func setupElements() {
        [topControlsStack, titleLabel, searchBar, backLogo, underLogoLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Top controls: кнопка + пикер
            topControlsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            topControlsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            topControlsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: topControlsStack.topAnchor, constant: 4),
            datePicker.bottomAnchor.constraint(equalTo: topControlsStack.bottomAnchor, constant: 4),
            
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: topControlsStack.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // Поиск
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            // Лого
            backLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backLogo.heightAnchor.constraint(equalToConstant: 80),
            backLogo.widthAnchor.constraint(equalToConstant: 80),
            backLogo.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220),
            
            // Подпись под лого
            underLogoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            underLogoLabel.topAnchor.constraint(equalTo: backLogo.bottomAnchor, constant: 8)
        ])
    }
}
