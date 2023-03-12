//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Ruslan Dalgatov on 11.03.2023.
//

import UIKit

class MyPageViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        let page1 = MainViewController()
        let page2 = secondViewController()
        pages = [page1, page2]
        setViewControllers([page1], direction: .forward, animated: true, completion: nil)
        
        configurePageControl()
    }
    
    func configurePageControl() {
        let pageControl = UIPageControl()
        UIPageControl.appearance(whenContainedInInstancesOf: [MyPageViewController.self])
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.backgroundColor = .clear
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 200),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}

extension MyPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentVC = pageViewController.viewControllers?.first else {
            return 0
        }
        return pages.firstIndex(of: currentVC) ?? 0
    }
    
}
