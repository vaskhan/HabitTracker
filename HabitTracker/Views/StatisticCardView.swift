//
//  StatisticCardView.swift
//  HabitTracker
//
//  Created by Василий Ханин on 19.05.2025.
//

import UIKit

final class StatisticCardView: UIView {
    private let numberLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let gradientBorder = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    init(number: Int, description: String) {
        super.init(frame: .zero)
        setupUI(number: number, description: description)
        setupGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    private func setupUI(number: Int, description: String) {
        backgroundColor = .whiteDayNew
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        numberLabel.font = UIFont(name: "SFPro-Bold", size: 34)
        numberLabel.text = "\(number)"
        numberLabel.textColor = .blackDayNew
        
        descriptionLabel.font = UIFont(name: "SFPro-Medium", size: 12)
        descriptionLabel.text = description
        descriptionLabel.textColor = .blackDayNew
        
        let stack = UIStackView(arrangedSubviews: [numberLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 7
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    private func setupGradientBorder() {
        gradientBorder.colors = [
            UIColor(hex: "#FD4C49").cgColor,
            UIColor(hex: "#46E69D").cgColor,
            UIColor(hex: "#007BFA").cgColor
        ]
        gradientBorder.startPoint = CGPoint(x: 0, y: 0)
        gradientBorder.endPoint = CGPoint(x: 1, y: 0)
        gradientBorder.mask = shapeLayer
        layer.addSublayer(gradientBorder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientBorder.frame = bounds
        shapeLayer.frame = bounds
        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        let insetBounds = bounds.insetBy(dx: 1, dy: 1)
        let innerPath = UIBezierPath(roundedRect: insetBounds, cornerRadius: 15)
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true
        
        shapeLayer.path = outerPath.cgPath
        shapeLayer.fillRule = .evenOdd
        shapeLayer.fillColor = UIColor.black.cgColor
    }
    
    func configure(number: Int) {
        numberLabel.text = "\(number)"
    }

}
