//
//  CategoryCell.swift
//  HabitTracker
//
//  Created by Василий Ханин on 03.05.2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .fieldBackground.withAlphaComponent(0.3)
        contentView.layer.masksToBounds = true
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.font = UIFont(name: "SFPro-Regular", size: 17)
        titleLabel.textColor = .blackDayNew
        
        separator.backgroundColor = .grayText
        
        [titleLabel, separator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(title: String, isFirst: Bool, isLast: Bool) {
        titleLabel.text = title
        applyCorners(isFirst: isFirst, isLast: isLast)
        separator.isHidden = isLast
    }
    
    private func applyCorners(isFirst: Bool, isLast: Bool) {
        contentView.layer.cornerRadius = 0
        contentView.layer.maskedCorners = []
        
        switch (isFirst, isLast) {
        case (true, true):
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner
            ]
        case (true, false):
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (false, true):
            contentView.layer.cornerRadius = 16
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (false, false):
            contentView.layer.cornerRadius = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
}

