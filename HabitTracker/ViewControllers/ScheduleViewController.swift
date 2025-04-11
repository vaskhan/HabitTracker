//
//  ScheduleViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 06.04.2025.
//


import UIKit

final class ScheduleViewController: UIViewController {
    
    var selectedDays: Set<DayOfWeek> = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var onSchedulePicked: (([DayOfWeek]) -> Void)?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textColor = .blackDay
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        [titleLabel, tableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "ScheduleCell")
        
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneTapped() {
        onSchedulePicked?(Array(selectedDays).sorted(by: { $0.rawValue < $1.rawValue }))
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DayOfWeek.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let day = DayOfWeek(rawValue: indexPath.row + 1),
              let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }

        let isOn = selectedDays.contains(day)
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == DayOfWeek.allCases.count - 1

        cell.configure(day: day.fullNameDay, isOn: isOn, isLast: isLast) { [weak self] isSelected in
            if isSelected {
                self?.selectedDays.insert(day)
            } else {
                self?.selectedDays.remove(day)
            }
        }

        cell.settingsCorners(isFirst: isFirst, isLast: isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

