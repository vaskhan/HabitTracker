//
//  CategorySelectionViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 03.05.2025.
//

import UIKit

final class CategorySelectionViewController: UIViewController {
    private let viewModel: TrackerCategoryViewModel
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    var onCategorySelected: ((TrackerCategoryCoreData) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.textColor = .blackDay
        label.textAlignment = .center
        return label
    }()
    
    private let backLogo: UIImageView = {
        let image = UIImage(named: "backLogoTrackerScreen")
        let view = UIImageView(image: image)
        return view
    }()
    
    private let underLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.textColor = .blackDay
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .blackDay
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.layer.cornerRadius = 16
        return button
    }()
    
    init(viewModel: TrackerCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        viewModel.onCategoriesUpdated = { [weak self] _ in
            self?.updateUI()
        }
        
        viewModel.loadCategories()
    }
    
    private func setupUI() {
        [titleLabel, tableView, backLogo, underLogoLabel, addCategoryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        
        addCategoryButton.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            backLogo.heightAnchor.constraint(equalToConstant: 80),
            backLogo.widthAnchor.constraint(equalToConstant: 80),
            
            underLogoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            underLogoLabel.topAnchor.constraint(equalTo: backLogo.bottomAnchor, constant: 8),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateUI() {
        let isEmpty = viewModel.numberOfCategories == 0
        backLogo.isHidden = !isEmpty
        underLogoLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty == true ? true : false
        tableView.reloadData()
    }
    
    @objc private func addCategoryTapped() {
        let createVC = CreateCategoryViewController()
        
        createVC.onCategoryCreated = { [weak self] title in
            self?.viewModel.addCategory(with: title)
            self?.viewModel.loadCategories()
        }
        
        presentSheet(createVC)
    }
}

extension CategorySelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }

        let category = viewModel.category(at: indexPath.row)
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == viewModel.numberOfCategories - 1

        cell.configure(title: category.title ?? "Без названия", isFirst: isFirst, isLast: isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = viewModel.category(at: indexPath.row)
        onCategorySelected?(selected)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

