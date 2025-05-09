//
//  OnboardingViewController.swift
//  HabitTracker
//
//  Created by Василий Ханин on 02.05.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var onFinished: (() -> Void)?
    lazy var pages: [UIViewController] = {
        
        let blueScreen = UIViewController()
        let blueImage = UIImageView(image: UIImage(named: "blueScreenImage"))
        blueImage.contentMode = .scaleAspectFill
        blueImage.translatesAutoresizingMaskIntoConstraints = false
        
        let blueLabel = UILabel()
        blueLabel.text = L10n.onboardingTitleBlue
        blueLabel.font = UIFont(name: "SFPro-Bold", size: 32)
        blueLabel.textColor = .blackDay
        blueLabel.textAlignment = .center
        blueLabel.numberOfLines = 0
        blueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let blueButton = UIButton(type: .system)
        blueButton.setTitle(L10n.onboardingButton, for: .normal)
        blueButton.backgroundColor = .blackDay
        blueButton.setTitleColor(.white, for: .normal)
        blueButton.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        blueButton.layer.cornerRadius = 16
        blueButton.translatesAutoresizingMaskIntoConstraints = false
        blueButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        blueScreen.view.addSubview(blueImage)
        blueScreen.view.addSubview(blueLabel)
        blueScreen.view.addSubview(blueButton)
        blueScreen.view.sendSubviewToBack(blueImage)
        
        NSLayoutConstraint.activate([
            blueImage.topAnchor.constraint(equalTo: blueScreen.view.topAnchor),
            blueImage.bottomAnchor.constraint(equalTo: blueScreen.view.bottomAnchor),
            blueImage.leadingAnchor.constraint(equalTo: blueScreen.view.leadingAnchor),
            blueImage.trailingAnchor.constraint(equalTo: blueScreen.view.trailingAnchor),
            
            blueLabel.leadingAnchor.constraint(equalTo: blueScreen.view.leadingAnchor, constant: 16),
            blueLabel.trailingAnchor.constraint(equalTo: blueScreen.view.trailingAnchor, constant: -16),
            blueLabel.bottomAnchor.constraint(equalTo: blueButton.topAnchor, constant: -160),
            
            blueButton.leadingAnchor.constraint(equalTo: blueScreen.view.leadingAnchor, constant: 16),
            blueButton.trailingAnchor.constraint(equalTo: blueScreen.view.trailingAnchor, constant: -16),
            blueButton.bottomAnchor.constraint(equalTo: blueScreen.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            blueButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let redScreen = UIViewController()
        let redImage = UIImageView(image: UIImage(named: "redScreenImage"))
        redImage.contentMode = .scaleAspectFill
        redImage.translatesAutoresizingMaskIntoConstraints = false
        
        let redLabel = UILabel()
        redLabel.text = L10n.onboardingTitleRed
        redLabel.font = UIFont(name: "SFPro-Bold", size: 32)
        redLabel.textColor = .blackDay
        redLabel.textAlignment = .center
        redLabel.numberOfLines = 0
        redLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let redButton = UIButton(type: .system)
        redButton.setTitle(L10n.onboardingButton, for: .normal)
        redButton.backgroundColor = .blackDay
        redButton.setTitleColor(.white, for: .normal)
        redButton.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        redButton.layer.cornerRadius = 16
        redButton.translatesAutoresizingMaskIntoConstraints = false
        redButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        redScreen.view.addSubview(redImage)
        redScreen.view.addSubview(redLabel)
        redScreen.view.addSubview(redButton)
        redScreen.view.sendSubviewToBack(redImage)
        
        NSLayoutConstraint.activate([
            redImage.topAnchor.constraint(equalTo: redScreen.view.topAnchor),
            redImage.bottomAnchor.constraint(equalTo: redScreen.view.bottomAnchor),
            redImage.leadingAnchor.constraint(equalTo: redScreen.view.leadingAnchor),
            redImage.trailingAnchor.constraint(equalTo: redScreen.view.trailingAnchor),
            
            redLabel.leadingAnchor.constraint(equalTo: redScreen.view.leadingAnchor, constant: 16),
            redLabel.trailingAnchor.constraint(equalTo: redScreen.view.trailingAnchor, constant: -16),
            redLabel.bottomAnchor.constraint(equalTo: redButton.topAnchor, constant: -160),
            
            redButton.leadingAnchor.constraint(equalTo: redScreen.view.leadingAnchor, constant: 16),
            redButton.trailingAnchor.constraint(equalTo: redScreen.view.trailingAnchor, constant: -16),
            redButton.bottomAnchor.constraint(equalTo: redScreen.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            redButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return [blueScreen, redScreen]
    }()
    
    override init(transitionStyle: UIPageViewController.TransitionStyle = .scroll,
                  navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = .gray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
    
    @objc private func didTapStart() {
        onFinished?()
    }
}

