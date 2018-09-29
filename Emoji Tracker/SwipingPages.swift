//
//  SwipingPages.swift
//  Emoji Tracker
//
//  Created by Ula Kuczynska on 7/26/18.
//  Copyright © 2018 Ula Kuczynska. All rights reserved.
//

import UIKit

class SwipingPages: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "newTracker1")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "newTracker2")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "newTracker3")
        
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([page1], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        print("back")
        
        let current = pages.index(of: viewController)!
        
        if current == 0 { return nil }
        
        let previous = abs((current - 1) % pages.count)
        return pages[previous]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        print("forth")
        
        let current = pages.index(of: viewController)!
        
         if current == (pages.count - 1) { return nil }
        
        let next = abs((current + 1) % pages.count)
        return pages[next]
    }

}
