//
//  TrackerFilterViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 18.05.2025.
//

import UIKit

final class TrackerFilterViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let filters = EnumTrackerFilter.allCases
    private var currentFilter: EnumTrackerFilter = .all
    
    var onFilterSelected: ((EnumTrackerFilter) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textColor = .blackDay
        label.textAlignment = .center
        return label
    }()
    
    init(currentFilter: EnumTrackerFilter) {
        self.currentFilter = currentFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupUI()
    }
    
    private func setupUI() {
        [titleLabel, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(FilterCell.self, forCellReuseIdentifier: "FilterCell")
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TrackerFilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        let filter = filters[indexPath.row]
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == filters.count - 1
        let isChecked = filter == currentFilter
        
        cell.configure(title: filter.title, isChecked: isChecked, isFirst: isFirst, isLast: isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = filters[indexPath.row]
        onFilterSelected?(selected)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

