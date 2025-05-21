//
//  TrackerTypeSelectionViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 04.04.2025.
//


import UIKit

final class TrackerSelectionViewController: UIViewController {
    var onCreateTracker: ((TrackerCategory) -> Void)?
    private let viewModel: TrackerViewModel
    private let categoryViewModel: TrackerCategoryViewModel

    init(viewModel: TrackerViewModel, categoryViewModel: TrackerCategoryViewModel) {
        self.viewModel = viewModel
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.createTrackerTitle
        label.textColor = .blackDayNew
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.habit, for: .normal)
        button.backgroundColor = .blackDayNew
        button.setTitleColor(.whiteDayNew, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.event, for: .normal)
        button.backgroundColor = .blackDayNew
        button.setTitleColor(.whiteDayNew, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDayNew
        setupLayout()
        habitButton.addTarget(self, action: #selector(habitTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventTapped), for: .touchUpInside)
    }
    
    @objc private func habitTapped() {
        let createHabitVC = CreateHabitViewController()
        createHabitVC.viewModel = viewModel
        createHabitVC.categoryViewModel = categoryViewModel
        createHabitVC.onCreateTracker = { [weak self] newCategory in
            self?.onCreateTracker?(newCategory)
            self?.dismissToRoot()
        }
        presentSheet(createHabitVC)
    }

    @objc private func eventTapped() {
        let createEventVC = CreateEventViewController()
        createEventVC.viewModel = viewModel
        createEventVC.categoryViewModel = categoryViewModel
        createEventVC.onCreateTracker = { [weak self] newCategory in
            self?.onCreateTracker?(newCategory)
            self?.dismissToRoot()
        }
        presentSheet(createEventVC)
    }

    
    private func setupLayout() {
        [titleLabel, habitButton, eventButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 295),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
