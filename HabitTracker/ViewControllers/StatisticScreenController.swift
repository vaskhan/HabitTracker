//
//  StatisticScreenController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 29.03.2025.
//

import UIKit

final class StatisticScreenController: UIViewController {
    
    private var viewModel: StatisticViewModel
    private var statCards: [StatisticCardView] = []
    private var statStackView: UIStackView?
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = L10n.statistic
        title.font = UIFont(name: "SFPro-Bold", size: 34)
        title.textColor = .blackDay
        return title
    }()
    
    private let backgroundLogo: UIImageView = {
        let image = UIImage(named: "placeholderStatistic")
        let view = UIImageView(image: image)
        return view
    }()
    
    private let underLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.textColor = .blackDay
        return label
    }()
    
    init(viewModel: StatisticViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupElements()
        setupConstraints()
    }
    
    func update(with viewModel: StatisticViewModel) {
        self.viewModel = viewModel
        statStackView?.removeFromSuperview()
        backgroundLogo.removeFromSuperview()
        underLogoLabel.removeFromSuperview()
        setupElements()
        setupConstraints()
    }
    
    private func setupElements() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if viewModel.hasStatistics {
            backgroundLogo.isHidden = true
            underLogoLabel.isHidden = true
            
            statCards = [
                StatisticCardView(number: viewModel.bestPeriod, description: "Лучший период"),
                StatisticCardView(number: viewModel.idealDays, description: "Идеальные дни"),
                StatisticCardView(number: viewModel.completedTrackers, description: "Трекеров завершено"),
                StatisticCardView(number: viewModel.averageValue, description: "Среднее значение")
            ]
            
            let stackView = UIStackView(arrangedSubviews: statCards)
            stackView.axis = .vertical
            stackView.spacing = 12
            view.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            self.statStackView = stackView
        } else {
            view.addSubview(backgroundLogo)
            view.addSubview(underLogoLabel)
            backgroundLogo.translatesAutoresizingMaskIntoConstraints = false
            underLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        if let stackView = statStackView {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        } else {
            NSLayoutConstraint.activate([
                backgroundLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                backgroundLogo.heightAnchor.constraint(equalToConstant: 80),
                backgroundLogo.widthAnchor.constraint(equalToConstant: 80),
                backgroundLogo.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
                
                underLogoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                underLogoLabel.topAnchor.constraint(equalTo: backgroundLogo.bottomAnchor, constant: 8)
            ])
        }
    }
}
