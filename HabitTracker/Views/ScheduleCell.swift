//
//  ScheduleCell.swift
//  HabitTracker
//
//  Created by Василий Ханин on 06.04.2025.
//


import UIKit

final class ScheduleCell: UITableViewCell {
    private let dayLabel = UILabel()
    private let toggle = UISwitch()
    private let separator = UIView()
    
    private var toggleHandler: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        setupUI()
    }
    
    private func setupUI() {
        dayLabel.font = UIFont(name: "SFPro-Regular", size: 17)
        dayLabel.textColor = .blackDay
        
        toggle.onTintColor = .blueSwitch
        
        separator.backgroundColor = .grayText
        
        [dayLabel, toggle, separator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
    }
    
    func configure(day: String, isOn: Bool, isLast: Bool, onToggle: @escaping (Bool) -> Void) {
        dayLabel.text = day
        toggle.isOn = isOn
        self.toggleHandler = onToggle
        separator.isHidden = isLast
    }
    
    func settingsCorners(isFirst: Bool, isLast: Bool) {
        contentView.layer.cornerRadius = 0
        contentView.layer.maskedCorners = []
        
        if isFirst {
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @objc private func toggleChanged() {
        toggleHandler?(toggle.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
}
