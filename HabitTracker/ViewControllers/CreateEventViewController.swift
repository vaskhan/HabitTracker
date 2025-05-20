//
//  CreateTrackerViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 04.04.2025.
//
import UIKit

final class CreateEventViewController: UIViewController {
    var onCreateTracker: ((TrackerCategory) -> Void)?
    var viewModel: TrackerViewModel?
    var categoryViewModel: TrackerCategoryViewModel?
    
    private var selectedCategory: TrackerCategory? {
        didSet {
            updateCategoryUI()
            updateCreateButtonState()
        }
    }
    
    private let emojiAndColorPicker = EmojiAndColorPickerView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.newEventButton
        label.textColor = .blackDayNew
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = L10n.trackerNamePlaceholder
        field.textColor = .grayText
        field.font = UIFont(name: "SFPro-Regular", size: 17)
        field.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        field.layer.cornerRadius = 16
        field.setLeftPaddingPoints(16)
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private let categoryButtonView = CreateOptionRowView(title: L10n.categoryLabel)
    
    private let categoryContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
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
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.categoryCreateButton, for: .normal)
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
        view.backgroundColor = .whiteDayNew
        setupUI()
        updateCategoryUI()
        updateCreateButtonState()
        nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        enableHideKeyboardOnTap()
        scrollView.keyboardDismissMode = .onDrag
        emojiAndColorPicker.onChange = { [weak self] in
            self?.updateCreateButtonState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Private Methods
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
        
        [titleLabel, nameField, categoryContainer, emojiAndColorPicker, cancelButton, createButton].forEach {
            categoryContainer.addSubview(categoryButtonView)
            categoryButtonView.translatesAutoresizingMaskIntoConstraints = false
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 75),
            
            categoryContainer.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            categoryContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryContainer.heightAnchor.constraint(equalToConstant: 75),
            
            categoryButtonView.topAnchor.constraint(equalTo: categoryContainer.topAnchor),
            categoryButtonView.bottomAnchor.constraint(equalTo: categoryContainer.bottomAnchor),
            categoryButtonView.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor),
            categoryButtonView.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor),
            
            emojiAndColorPicker.topAnchor.constraint(equalTo: categoryButtonView.bottomAnchor, constant: 32),
            emojiAndColorPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiAndColorPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: emojiAndColorPicker.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.topAnchor.constraint(equalTo: emojiAndColorPicker.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
            
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        categoryButtonView.addGestureRecognizer(tapGesture)
    }
    
    private func updateCategoryUI() {
        categoryButtonView.updateSubtitle(selectedCategory?.title ?? "")
    }
    
    private func updateCreateButtonState() {
        let nameFilled = !(nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let categoryChosen = selectedCategory != nil
        let emojiChosen = emojiAndColorPicker.selectedEmoji != nil
        let colorChosen = emojiAndColorPicker.selectedColor != nil
        createButton.isEnabled = nameFilled && categoryChosen && emojiChosen && colorChosen
        createButton.backgroundColor = createButton.isEnabled ? .blackDayNew : .grayText
        
        let textColorName = createButton.isEnabled ? "whiteDayNew" : "justWhite"
        let textColor = UIColor(named: textColorName)
        createButton.setTitleColor(textColor, for: .normal)
    }
    
    @objc private func categoryTapped() {
        guard let viewModel = categoryViewModel else { return }
        let categoryVC = CategorySelectionViewController(viewModel: viewModel)
        categoryVC.onCategorySelected = { [weak self] selectedCategory in
            self?.selectedCategory = TrackerCategory(title: selectedCategory.title ?? L10n.trackerNameMissing, trackers: [])
            self?.updateCategoryUI()
            self?.updateCreateButtonState()
        }
        presentSheet(categoryVC)
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
            let selectedCategory = selectedCategory
        else { return }
        
        guard
            let coreDataCategory = viewModel?.categoryStore.createCategoryIfNeeded(title: selectedCategory.title)
        else { return }
        
        viewModel?.createTracker(
            name: name,
            emoji: emoji,
            color: color,
            schedule: [],
            categoryTitle: selectedCategory.title,
            coreDataCategory: coreDataCategory
        )
        
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


