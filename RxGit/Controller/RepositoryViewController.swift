//
//  RepositoryViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 2/17/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {
    var pageViewController: UIPageViewController!
    var overviewController: RepositoryOverviewController!
    var pullRequestController: RepositoryPullRequestViewController!
    var codeController: RepositoryCodeViewController!
    var viewControllers = [UIViewController]()
    
    @IBOutlet weak var sliderView: UIView!
    var sliderImageView: UIImageView!
    var lastPageIndex: Int = 0
    var currentPageIndex: Int = 0 {
        didSet {
            let offset = self.view.frame.width / 3.0 * CGFloat(currentPageIndex)
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.sliderImageView.frame.origin = CGPoint(x: offset, y: -1)
            }
            if currentPageIndex > lastPageIndex {
                self.pageViewController.setViewControllers([viewControllers[currentPageIndex]], direction: .forward, animated: true, completion: nil)
            } else {
                self.pageViewController.setViewControllers([viewControllers[currentPageIndex]], direction: .reverse, animated: true, completion: nil)
            }
            lastPageIndex = currentPageIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = (self.children.first as! UIPageViewController)
        overviewController = (storyboard?.instantiateViewController(withIdentifier: "OverviewControllerID") as! RepositoryOverviewController)
        pullRequestController = (storyboard?.instantiateViewController(withIdentifier: "PullRequestControllerID") as! RepositoryPullRequestViewController)
        codeController = (storyboard?.instantiateViewController(withIdentifier: "CodeControllerID") as! RepositoryCodeViewController)
        pageViewController.dataSource = self
        pageViewController.setViewControllers([overviewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width / 3.0, height: 3.0))
        sliderImageView.image = UIImage(named: "slider")
        sliderView.addSubview(sliderImageView)
        
        viewControllers.append(overviewController)
        viewControllers.append(pullRequestController)
        viewControllers.append(codeController)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RepositoryViewController.currentPageChanged(notification:)), name: Notification.Name(rawValue: "currentPageChanged"), object: nil)
    }
    
    @IBAction func changePage(_ sender: UIButton) {
        currentPageIndex = sender.tag
    }
    
    @objc func currentPageChanged(notification: Notification) {
        currentPageIndex = notification.object as! Int
    }
    
}

extension RepositoryViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: RepositoryOverviewController.self) {
            return pullRequestController
        }
        else if viewController.isKind(of: RepositoryPullRequestViewController.self) {
            return codeController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: RepositoryCodeViewController.self) {
            return pullRequestController
        }
        else if viewController.isKind(of: RepositoryPullRequestViewController.self) {
            return overviewController
        }
        return nil
    }
}
