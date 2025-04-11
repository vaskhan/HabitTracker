//
//  CreateHabitViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 06.04.2025.
//


import UIKit

final class CreateHabitViewController: UIViewController {
    
    // MARK: - Public
    var onCreateTracker: ((TrackerCategory) -> Void)?
    
    private var selectedCategory: TrackerCategory? = TrackerCategory(title: "Домашний уют", trackers: []) {
        didSet {
            updateCategoryUI()
            updateCreateButtonState()
        }
    }
    
    private var selectedSchedule: [DayOfWeek] = [] {
        didSet {
            updateScheduleUI()
            updateCreateButtonState()
        }
    }
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textColor = .blackDay
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.textColor = .blackDay
        field.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        field.layer.cornerRadius = 16
        field.setLeftPaddingPoints(16)
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private let optionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let categoryButtonView = CreateOptionRowView(title: "Категория")
    private let scheduleButtonView = CreateOptionRowView(title: "Расписание")
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayText
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
        setupActions()
        
        updateCategoryUI()
        updateCreateButtonState()
        nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        enableHideKeyboardOnTap()
    }
    
    // MARK: - Setup
    private func setupUI() {
        [titleLabel, nameField, optionContainerView, cancelButton, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [categoryButtonView, dividerView, scheduleButtonView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            optionContainerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 75),
            
            optionContainerView.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            optionContainerView.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            optionContainerView.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            
            categoryButtonView.topAnchor.constraint(equalTo: optionContainerView.topAnchor),
            categoryButtonView.leadingAnchor.constraint(equalTo: optionContainerView.leadingAnchor),
            categoryButtonView.trailingAnchor.constraint(equalTo: optionContainerView.trailingAnchor),
            categoryButtonView.heightAnchor.constraint(equalToConstant: 75),
            
            dividerView.topAnchor.constraint(equalTo: categoryButtonView.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: optionContainerView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: optionContainerView.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            scheduleButtonView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            scheduleButtonView.leadingAnchor.constraint(equalTo: optionContainerView.leadingAnchor),
            scheduleButtonView.trailingAnchor.constraint(equalTo: optionContainerView.trailingAnchor),
            scheduleButtonView.heightAnchor.constraint(equalToConstant: 75),
            scheduleButtonView.bottomAnchor.constraint(equalTo: optionContainerView.bottomAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        categoryButtonView.addGestureRecognizer(categoryTap)
        
        let scheduleTap = UITapGestureRecognizer(target: self, action: #selector(scheduleTapped))
        scheduleButtonView.addGestureRecognizer(scheduleTap)
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }
    
    private func updateCategoryUI() {
        categoryButtonView.updateSubtitle(selectedCategory?.title ?? "")
    }
    
    private func updateCreateButtonState() {
        let nameFilled = !(nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let categoryChosen = selectedCategory != nil
        let scheduleChosen = !selectedSchedule.isEmpty
        createButton.isEnabled = nameFilled && categoryChosen && scheduleChosen
        createButton.backgroundColor = createButton.isEnabled ? .blackDay : .gray
    }
    
    private func updateScheduleUI() {
        if selectedSchedule.isEmpty {
            scheduleButtonView.updateSubtitle(nil)
        } else {
            let days = selectedSchedule
                .map { $0.shortNameDay }
                .joined(separator: ", ")
            scheduleButtonView.updateSubtitle(days)
        }
    }
    
    // MARK: - Actions
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
            color: .systemOrange,
            emoji: "🖼️",
            schedule: selectedSchedule
        )
        
        let newCategory = TrackerCategory(
            title: selectedCategory.title,
            trackers: selectedCategory.trackers + [newTracker]
        )
        
        onCreateTracker?(newCategory)
        
        dismissToRoot()
    }
    
    @objc private func categoryTapped() {
        print("Выбор категории")
    }
    
    @objc private func scheduleTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedDays = Set(selectedSchedule)
        
        scheduleVC.onSchedulePicked = { [weak self] selected in
            self?.selectedSchedule = selected
            self?.updateScheduleUI()
            self?.updateCreateButtonState()
        }
        presentSheet(scheduleVC)
    }
}

// MARK: - Кастомный блок с заголовком, подзаголовком и стрелкой
final class CreateOptionRowView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevron = UIImageView(image: UIImage(named: "chevronForField"))
    
    private var centerYConstraint: NSLayoutConstraint!
    private var topTitleConstraint: NSLayoutConstraint!
    private var bottomSubtitleConstraint: NSLayoutConstraint!
    
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        titleLabel.text = title
        titleLabel.font = UIFont(name: "SFPro-Regular", size: 17)
        titleLabel.textColor = .blackDay
        
        subtitleLabel.font = UIFont(name: "SFPro-Regular", size: 17)
        subtitleLabel.textColor = .grayText
        
        [titleLabel, subtitleLabel, chevron].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        // Chevron
        NSLayoutConstraint.activate([
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Заголовок
        topTitleConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        centerYConstraint = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        // Подзаголовок
        bottomSubtitleConstraint = subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        updateLayout(animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    // MARK: - Public
    func updateSubtitle(_ text: String?) {
        subtitleLabel.text = text
        updateLayout(animated: true)
    }
    
    // MARK: - Private
    private func updateLayout(animated: Bool) {
        [topTitleConstraint, centerYConstraint, bottomSubtitleConstraint].forEach { $0.isActive = false }
        
        if let text = subtitleLabel.text, !text.isEmpty {
            topTitleConstraint.isActive = true
            bottomSubtitleConstraint.isActive = true
        } else {
            centerYConstraint.isActive = true
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
}


