//
//  IntroPageViewController.swift
//  Resume
//
//  Created by Varun Wadhwa on 28/05/18.
//  Copyright © 2018 VM User. All rights reserved.
//

import UIKit

class IntroPageViewController:  UIPageViewController {
    var logoSize : CGSize = CGSize.init(width: 102, height: 277)
    let skipTitle = "Skip "
    var skipButton : UIButton?
    
    var skipButtonHidden : Bool {
        set(status){
            if let skipButton = skipButton {
                skipButton.isHidden = status
            }
        }
        get {
            guard let skipButton = skipButton ,  skipButton.isHidden else {return false}
            return true
        }
    }
    
    lazy var orderedViewControllers: [UIViewController] = {
        return self.getIntroVC()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        setupView()
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPageIndicators()
        setNavHidden()
    }
    
    func setPageIndicators() {
        let subViews: NSArray = view.subviews as NSArray
        var scrollView: UIScrollView? = nil
        var pageControl: UIPageControl? = nil
        for view in subViews {
            if view is UIScrollView {
                scrollView = view as? UIScrollView
            } else if view is UIPageControl {
                pageControl = view as? UIPageControl
                pageControl?.pageIndicatorTintColor = ColorCode.applicationBlue.withAlphaComponent(0.4)
                pageControl?.currentPageIndicatorTintColor = ColorCode.applicationBlue
                pageControl?.frame.origin.y = self.view.frame.size.height - (11 + (pageControl?.frame.size.height)!)
            }
        }
        if (scrollView != nil && pageControl != nil) {
            scrollView?.frame = view.bounds
            view.bringSubviewToFront(pageControl!)
        }
    }
    
    func setNavHidden() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    } 
    
    func setupView() {
        skipButton = setSkipButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: skipButton!)
    }
    
    func setSkipButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(skipTitle, for: .normal)
        button.titleLabel?.font =  UIFont(name: "SanFranciscoText-Regular", size: 20)
        button.tintColor = ColorCode.applicationBlue
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.skipAction), for: .touchUpInside)
        return button
    }
    
    @objc func skipAction() {
        let lastPageIndex = orderedViewControllers.count-1
        setViewControllers([orderedViewControllers[lastPageIndex]], direction: .forward, animated: true, completion: nil)
        skipButtonHidden = true
    }
    
    func getIntroVC() -> [UIViewController] {
        var subVc : [UIViewController] = []
        IntroViewControllerConfig.getData().forEach{ introViewConfig in
            let vc = UIStoryboard.introVC()
            vc.centerImage = introViewConfig.centerImage
            vc.headingTitle = introViewConfig.headingTitle
            vc.subTitle = introViewConfig.subTitle
            vc.screenTitle = introViewConfig.screenTitle
            subVc.append(vc)
        }
        subVc.append(UIStoryboard.prefilledCommunity())
        return subVc
    }
    
    func ifLastPage(for pageViewController : UIPageViewController) -> Bool? {
        guard let viewControllers = pageViewController.viewControllers , viewControllers.count > 0 else {return nil}
        return viewControllers.first is PrefilledCommunityViewController
    }
}

extension IntroPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = orderedViewControllers.firstIndex(of: viewController)!
        let previousIndex = currentIndex - 1
        return (previousIndex == -1) ? nil : orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = orderedViewControllers.firstIndex(of: viewController)!
        let nextIndex = currentIndex + 1
        return (nextIndex == orderedViewControllers.count) ? nil : orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let status = ifLastPage(for : pageViewController) , status {
            let lastIndex =  orderedViewControllers.count-1
            return lastIndex
        }
        return 0
    }
    
}

extension IntroPageViewController : UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let status = ifLastPage(for : pageViewController) {
            skipButtonHidden = status
        }
    }
}

