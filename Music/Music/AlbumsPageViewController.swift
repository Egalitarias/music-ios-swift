//
//  AlbumsPageViewController.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class AlbumsPageViewController: UIPageViewController, UIPageViewControllerDataSource, PageDelegate {
    
    // MARK: - public variables
    
    var artistMbid: String?
    var albums: [[String:Any]] = []
    
    // MARK: - Private variables
    
    private var pageViewControllers: [UIViewController] = []
    
    // MARK: - Private backing variables

    fileprivate var lastFmApi: LastFmApi!
    
    // MARK: - Setters and getters

    private func getLastFmApi() -> LastFmApi {
        if lastFmApi != nil {
            return lastFmApi
        }
        
        lastFmApi = LastFmApi()
        lastFmApi.setPrototype(proto: Constants.proto)
        lastFmApi.setDomain(domain: Constants.domain)
        lastFmApi.setApiKey(apiKey: Constants.apiKey)
        
        return lastFmApi
    }

    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prime LastFmAp with Last Fm api parameters
        let _ = getLastFmApi()

        dataSource = self
        
        if let firstViewController = getViewControllers().first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }        
    }
    
    // MARK: - UIPageViewController methods
    
    func getViewControllers() -> [UIViewController] {
        if pageViewControllers.count > 0 {
            return pageViewControllers
        }
        
        var index = 0;
        
        for album in albums {
            let viewController = makeAlbumWithPageControlViewController(album: album, showDoneButton: index == (albums.count - 1), numberOfPages: albums.count, currentPage: index)
            pageViewControllers.append(viewController)
            
            index += 1
        }
        
        return pageViewControllers
    }
    
    // MARK: - UIPageViewControllerDataSource methods
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = getViewControllers().index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard getViewControllers().count > previousIndex else {
            return nil
        }
        
        return getViewControllers()[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = getViewControllers().index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard getViewControllers().count != nextIndex else {
            return nil
        }
        
        guard getViewControllers().count > nextIndex else {
            return nil
        }
        
        return getViewControllers()[nextIndex]
        
    }
    
    // MARK: - PageDelegate methods
    
    func didFinish(viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - AlbumPageViewController methods
    
    private func makeAlbumWithPageControlViewController(album: [String:Any], showDoneButton: Bool, numberOfPages: Int, currentPage: Int) -> UIViewController {
        let albumWithPageControlViewController = AlbumWithPageControlViewController()
        albumWithPageControlViewController.album = album
        albumWithPageControlViewController.delegate = self
        albumWithPageControlViewController.showDoneButton = showDoneButton
        albumWithPageControlViewController.numberOfPages = numberOfPages
        albumWithPageControlViewController.currentPage = currentPage
        
        return albumWithPageControlViewController
    }
    
}
