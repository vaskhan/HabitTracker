//
//  TrackerScreenController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 29.03.2025.
//

import UIKit

final class TrackerScreenController: UIViewController, UICollectionViewDelegate {
    
    let viewModel: TrackerViewModel
    private let categoryViewModel: TrackerCategoryViewModel
    
    // MARK: - UI Elements
    private let addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "buttonAddingLogo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .blackDay
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = .current
        return picker
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = L10n.trackers
        title.font = UIFont(name: "SFPro-Bold", size: 34)
        title.textColor = .blackDay
        return title
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = L10n.search
        bar.searchBarStyle = .minimal
        bar.backgroundImage = UIImage()
        bar.searchTextField.backgroundColor = .searchBarBackground
        
        if let imageView = bar.searchTextField.leftView as? UIImageView {
            imageView.tintColor = .searchBarPlaceholder
        }
        
        bar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.search,
            attributes: [.foregroundColor: UIColor(named: "searchBarPlaceholder") ?? .gray]
        )
        return bar
    }()
    
    private let backLogo: UIImageView = {
        let image = UIImage(named: "backLogoTrackerScreen")
        let view = UIImageView(image: image)
        return view
    }()
    
    private let underLogoLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.baseScreenPrompt
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.textColor = .blackDay
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "SectionHeader")
        return collectionView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.filters, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17)
        button.backgroundColor = .blueSwitch
        button.setTitleColor(.systemRed, for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyPlaceholder")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.nothingFound
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.textColor = .blackDay
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var currentDate: Date {
        Calendar.current.startOfDay(for: datePicker.date)
    }
    
    // MARK: - Init
    init(viewModel: TrackerViewModel, categoryViewModel: TrackerCategoryViewModel) {
        self.viewModel = viewModel
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteDay
        setupElements()
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        addTrackerButton.addTarget(self, action: #selector(didTapAddTracker), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        viewModel.loadTrackers()
        updateFilterButtonState()
        viewModel.onTrackersUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.updateFilterButtonState()
                self?.updateEmptyState()
            }
        }
        categoryViewModel.onCategoriesUpdated = { [weak self] _ in
            self?.viewModel.loadTrackers()
        }
        searchBar.searchTextField.addTarget(
            self,
            action: #selector(searchTextChanged(_:)),
            for: .editingChanged
        )
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 66, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.shared.sendEvent(event: "open", screen: "Main")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.sendEvent(event: "close", screen: "Main")
    }

    @objc private func searchTextChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        viewModel.filterTrackers(by: text)
        collectionView.reloadData()
        self.updateEmptyState()
    }
    
    @objc private func dateChanged() {
        if viewModel.currentFilter == .today {
            viewModel.currentFilter = .all
        }
        collectionView.reloadData()
        updateFilterButtonState()
        updateEmptyState()
    }
    
    @objc private func didTapAddTracker() {
        let createTrackerSelection = TrackerSelectionViewController(
            viewModel: self.viewModel,
            categoryViewModel: self.categoryViewModel
        )
        
        createTrackerSelection.onCreateTracker = { [weak self] newCategory in
            guard let self = self else { return }
            for tracker in newCategory.trackers {
                self.viewModel.addTracker(tracker, toCategoryWithTitle: newCategory.title)
            }
            self.viewModel.loadTrackers()
        }
        presentSheet(createTrackerSelection)
        AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "add_track")
    }
    
    
    // MARK: - Setup
    private func setupElements() {
        [titleLabel, searchBar, backLogo, underLogoLabel, collectionView, filterButton, emptyImageView, emptyLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
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
            underLogoLabel.topAnchor.constraint(equalTo: backLogo.bottomAnchor, constant: 8),
            
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -16),
            
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = TrackerFilterViewController(currentFilter: viewModel.currentFilter)
        filterVC.onFilterSelected = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.currentFilter = filter
            if filter == .today {
                let today = Date()
                self.datePicker.setDate(today, animated: true)
            }
            self.collectionView.reloadData()
            self.updateFilterButtonState()
            self.updateEmptyState()
        }
        presentSheet(filterVC)
        AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "filter")
    }
    
    private func updateEmptyState() {
        let hasAny = viewModel.hasAnyTrackers(for: currentDate)
        let visible = viewModel.totalVisibleTrackers(for: currentDate)
        
        if !hasAny {
            backLogo.isHidden = false
            underLogoLabel.isHidden = false
            emptyImageView.isHidden = true
            emptyLabel.isHidden = true
            filterButton.isHidden = true
        }
        else if visible == 0 {
            backLogo.isHidden = true
            underLogoLabel.isHidden = true
            emptyImageView.isHidden = false
            emptyLabel.isHidden = false
            filterButton.isHidden = false
        }
        else {
            backLogo.isHidden = true
            underLogoLabel.isHidden = true
            emptyImageView.isHidden = true
            emptyLabel.isHidden = true
            filterButton.isHidden = false
        }
    }
    
    private func updateFilterButtonState() {
        filterButton.isHidden = !viewModel.hasAnyTrackers(for: currentDate)
        filterButton.setTitleColor(
            viewModel.currentFilter == .all ? .white : .systemRed,
            for: .normal
        )
    }
}

extension TrackerScreenController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections(for: currentDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let total = viewModel.totalVisibleTrackers(for: currentDate)
        
        backLogo.isHidden = total > 0
        underLogoLabel.isHidden = total > 0
        
        return viewModel.numberOfItems(in: section, for: currentDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = viewModel.tracker(at: indexPath, for: currentDate)
        let completedDays = viewModel.completedDays(for: tracker.id)
        let isCompleted = viewModel.isTrackerCompleted(tracker.id, on: currentDate)
        
        cell.configure(with: tracker, completedDays: completedDays, isCompletedToday: isCompleted)
        
        cell.onPlusButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            let today = Calendar.current.startOfDay(for: Date())
            guard self.currentDate <= today else { return }
            
            self.viewModel.toggleTrackerCompletion(trackerID: tracker.id, on: self.currentDate)
            AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "track")

            if let cell = self.collectionView.cellForItem(at: indexPath) as? TrackerCell {
                let updatedCompletedDays = self.viewModel.completedDays(for: tracker.id)
                let updatedIsCompleted = self.viewModel.isTrackerCompleted(tracker.id, on: self.currentDate)
                cell.updateState(isCompletedToday: updatedIsCompleted, completedDays: updatedCompletedDays)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SectionHeader",
            for: indexPath
        ) as! SectionHeaderView
        
        let title = viewModel.sectionTitle(for: indexPath.section, date: currentDate)
        header.configure(with: title)
        return header
    }
}

extension TrackerScreenController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let width = (collectionView.bounds.width - spacing) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        else {
            return nil
        }
        
        return cell.targetedPreview()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        else {
            return nil
        }
        
        return cell.targetedPreview()
    }
}

extension TrackerScreenController {
    
    // MARK: - Контекстное меню для трекера
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        let tracker = viewModel.tracker(at: indexPath, for: currentDate)
        let isPinned = tracker.isPinned
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { [weak self] _ in
            let pinAction = UIAction(title: isPinned ? L10n.unpin : L10n.pin) { _ in
                self?.viewModel.togglePin(for: tracker)
            }
            let editAction = UIAction(title: L10n.edit) { [weak self] _ in
                self?.startEditFlow(for: tracker)
                AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "edit")
            }
            let deleteAction = UIAction(title: L10n.delete, attributes: .destructive) { [weak self] _ in
                self?.showDeleteConfirmation(for: tracker)
                AnalyticsService.shared.sendEvent(event: "click", screen: "Main", item: "delete")
            }
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
    
    private func findCategoryFor(tracker: Tracker) -> TrackerCategory? {
        return viewModel.categories.first { category in
            category.trackers.contains(where: { $0.id == tracker.id })
        }
    }
    
    func startEditFlow(for tracker: Tracker) {
        guard findCategoryFor(tracker: tracker) != nil else { return }
        
        let editVC = EditHabitViewController()
        editVC.viewModel = viewModel
        editVC.categoryViewModel = categoryViewModel
        editVC.editingTracker = tracker
        
        presentSheet(editVC)
    }
    
    func showDeleteConfirmation(for tracker: Tracker) {
        let alert = UIAlertController(
            title: "",
            message: L10n.confirmDeleteTracker,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: L10n.delete, style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteTracker(for: tracker)
        }))
        alert.addAction(UIAlertAction(title: L10n.cancelButton, style: .cancel))
        present(alert, animated: true)
    }
}
