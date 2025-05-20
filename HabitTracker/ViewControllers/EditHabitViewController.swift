//
//  EditHabitViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 17.05.2025.
//

import UIKit

final class EditHabitViewController: UIViewController {
    
    var onCreateTracker: ((TrackerCategory) -> Void)?
    var viewModel: TrackerViewModel?
    var categoryViewModel: TrackerCategoryViewModel?
    var editingTracker: Tracker?
    
    private var selectedCoreDataCategory: TrackerCategoryCoreData?
    private var counterTopConstraint: NSLayoutConstraint?
    private var nameTopToCounterConstraint: NSLayoutConstraint?
    private var nameTopToTitleConstraint: NSLayoutConstraint?
    private var scheduleButtonHeightConstraint: NSLayoutConstraint?
    
    private var selectedCategory: TrackerCategory? {
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
    
    private let emojiAndColorPicker = EmojiAndColorPickerView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.newHabitButton
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textColor = .blackDay
        label.textAlignment = .center
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPro-Bold", size: 32)
        label.textColor = .blackDay
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = L10n.trackerNamePlaceholder
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
    
    private let categoryButtonView = CreateOptionRowView(title: L10n.categoryLabel)
    private let scheduleButtonView = CreateOptionRowView(title: L10n.schedule)
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayText
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.cancelButton, for: .normal)
        button.setTitleColor(.redYPcolor, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.redYPcolor.cgColor
        button.layer.cornerRadius = 16
        button.backgroundColor = .clear
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.save, for: .normal)
        button.setTitleColor(.justWhite, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.layer.cornerRadius = 16
        button.backgroundColor = .grayText
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupUI()
        setupActions()
        
        emojiAndColorPicker.onChange = { [weak self] in
            self?.updateCreateButtonState()
        }
        
        if let tracker = editingTracker {
            titleLabel.text = L10n.editHabit
            counterLabel.text = String.localizedStringWithFormat(
                NSLocalizedString("numberOfDays", comment: ""),
                viewModel?.completedDays(for: tracker.id) ?? 0
            )
            nameField.text = tracker.name
            selectedSchedule = tracker.schedule
            emojiAndColorPicker.selectedEmoji = tracker.emoji
            emojiAndColorPicker.selectedColor = tracker.color
            
            if let category = viewModel?.categories.first(where: { $0.trackers.contains(where: { $0.id == tracker.id }) }),
               let coreCategory = viewModel?.categoryStore.fetchCategory(with: category.title) {
                selectedCategory = category
                selectedCoreDataCategory = coreCategory
            } else {
                dismiss(animated: true)
            }
        }
        hideElements()
        updateCreateButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tracker = editingTracker,
           !(viewModel?.trackerStore.trackerExists(withId: tracker.id) ?? true) {
            viewModel?.deleteTracker(for: tracker)
        }
    }
    
    private func hideElements() {
        let isIrregular = editingTracker?.schedule.isEmpty ?? false
        
        counterLabel.isHidden = isIrregular
        scheduleButtonView.isHidden = isIrregular
        dividerView.isHidden = isIrregular
        
        nameTopToCounterConstraint?.isActive = !isIrregular
        nameTopToTitleConstraint?.isActive = isIrregular
        scheduleButtonHeightConstraint?.constant = isIrregular ? 0 : 75
    }
    
    // MARK: - Setup
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        [titleLabel, counterLabel, nameField, optionContainerView, emojiAndColorPicker, cancelButton, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [categoryButtonView, dividerView, scheduleButtonView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            optionContainerView.addSubview($0)
        }
        
        counterTopConstraint = counterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24)
        counterTopConstraint?.isActive = true
        
        nameTopToCounterConstraint = nameField.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 40)
        nameTopToTitleConstraint = nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40)
        nameTopToCounterConstraint?.isActive = true
        
        scheduleButtonHeightConstraint = scheduleButtonView.heightAnchor.constraint(equalToConstant: 75)
        scheduleButtonHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            counterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
            scheduleButtonView.bottomAnchor.constraint(equalTo: optionContainerView.bottomAnchor),
            
            emojiAndColorPicker.topAnchor.constraint(equalTo: optionContainerView.bottomAnchor, constant: 32),
            emojiAndColorPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiAndColorPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: emojiAndColorPicker.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            saveButton.topAnchor.constraint(equalTo: emojiAndColorPicker.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    
    private func setupActions() {
        categoryButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categoryTapped)))
        scheduleButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scheduleTapped)))
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        updateCreateButtonState()
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        guard
            let name = nameField.text,
            let color = emojiAndColorPicker.selectedColor,
            let emoji = emojiAndColorPicker.selectedEmoji,
            let selectedCategory = selectedCategory,
            let coreDataCategory = selectedCoreDataCategory,
            let viewModel = viewModel
        else { return }
        
        let schedule = editingTracker?.schedule.isEmpty == true ? [] : selectedSchedule
        
        if let editing = editingTracker,
           viewModel.trackerStore.trackerExists(withId: editing.id) {
            let tracker = Tracker(
                id: editing.id,
                name: name,
                color: color,
                emoji: emoji,
                schedule: schedule,
                isPinned: editing.isPinned
            )
            viewModel.updateTracker(tracker, newCategory: coreDataCategory)
        } else {
            viewModel.createTracker(
                name: name,
                emoji: emoji,
                color: color,
                schedule: schedule,
                categoryTitle: selectedCategory.title,
                coreDataCategory: coreDataCategory
            )
        }
        
        dismissToRoot()
    }
    
    @objc private func categoryTapped() {
        guard let viewModel = categoryViewModel else { return }
        let categoryVC = CategorySelectionViewController(viewModel: viewModel)
        categoryVC.onCategorySelected = { [weak self] selectedCategory in
            self?.selectedCategory = TrackerCategory(title: selectedCategory.title ?? L10n.trackerNameMissing, trackers: [])
            self?.selectedCoreDataCategory = selectedCategory
        }
        presentSheet(categoryVC)
    }
    
    @objc private func scheduleTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedDays = Set(selectedSchedule)
        scheduleVC.onSchedulePicked = { [weak self] selected in
            self?.selectedSchedule = selected
        }
        presentSheet(scheduleVC)
    }
    
    private func updateCategoryUI() {
        categoryButtonView.updateSubtitle(selectedCategory?.title ?? "")
    }
    
    private func updateScheduleUI() {
        scheduleButtonView.updateSubtitle(selectedSchedule.isEmpty ? nil : selectedSchedule.map { $0.shortNameDay }.joined(separator: ", "))
    }
    
    private func updateCreateButtonState() {
        let nameFilled = !(nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let categoryChosen = selectedCategory != nil
        let emojiChosen = emojiAndColorPicker.selectedEmoji != nil
        let colorChosen = emojiAndColorPicker.selectedColor != nil
        let scheduleValid = editingTracker?.schedule.isEmpty == true || !selectedSchedule.isEmpty
        saveButton.isEnabled = nameFilled && categoryChosen && scheduleValid && emojiChosen && colorChosen
        saveButton.backgroundColor = saveButton.isEnabled ? .blackDay : .grayText
        let textColorName = saveButton.isEnabled ? "whiteDay" : "justWhite"
        let textColor = UIColor(named: textColorName)
        saveButton.setTitleColor(textColor, for: .normal)
    }
}
