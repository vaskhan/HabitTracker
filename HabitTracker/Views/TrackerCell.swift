//
//  TrackerCell.swift
//  HabitTracker
//
//  Created by Василий Ханин on 02.04.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    // MARK: -Public Properties
    var onPlusButtonTapped: (() -> Void)?
    
    // MARK: - UI Elements
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackDay
        return label
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "buttonPlus")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.backgroundColor = .whiteDay
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        return button
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .testCellColorGreen
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let pinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pin.fill"))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        [emojiLabel, titleLabel, pinImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        
        [daysLabel, plusButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    // MARK: - Configure
    func configure(with tracker: Tracker, completedDays: Int, isCompletedToday: Bool) {
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        let format = NSLocalizedString("numberOfDays", comment: "")
        let result = String.localizedStringWithFormat(format, completedDays)
        daysLabel.text = result
        
        cardView.backgroundColor = tracker.color
        
        let iconName = isCompletedToday ? "checkmark" : "plus"
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        plusButton.setImage(icon, for: .normal)
        plusButton.tintColor = .whiteDay
        plusButton.backgroundColor = tracker.color.withAlphaComponent(isCompletedToday ? 0.3 : 1.0)
        
        pinImageView.isHidden = !tracker.isPinned
    }
    
    func updateState(isCompletedToday: Bool, completedDays: Int) {
        let format = NSLocalizedString("numberOfDays", comment: "")
        let result = String.localizedStringWithFormat(format, completedDays)
        daysLabel.text = result
        
        let iconName = isCompletedToday ? "checkmark" : "plus"
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        plusButton.setImage(icon, for: .normal)
        plusButton.tintColor = .whiteDay
        plusButton.backgroundColor = cardView.backgroundColor?.withAlphaComponent(isCompletedToday ? 0.3 : 1.0)
    }
    
    func targetedPreview() -> UITargetedPreview {
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        )
        return UITargetedPreview(view: cardView, parameters: parameters)
    }

    // MARK: - Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            plusButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            
            pinImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            pinImageView.widthAnchor.constraint(equalToConstant: 8),
            pinImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    @objc private func plusButtonTapped() {
        onPlusButtonTapped?()
    }
}
