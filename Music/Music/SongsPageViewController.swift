//
//  SongsPageViewController.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class SongsPageViewController: UIPageViewController, UIPageViewControllerDataSource, PageDelegate {
    
    // MARK: - public variables
    
    var songs: [[String:Any]]?
    var albumImageUrl: String?

    // MARK: - Private variables
    
    private var pageViewControllers: [UIViewController] = []

    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if let songs = songs {
            
            for song in songs {
                let viewController = makeSongWithPageControlViewController(song: song, showDoneButton: index == (songs.count - 1), numberOfPages: songs.count, currentPage: index)
                pageViewControllers.append(viewController)
                
                index += 1
            }
        }
        
        return pageViewControllers
    }

    // MARK: - UIPageViewControllerDataSource methods
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = getViewControllers().index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard getViewControllers().count > previousIndex else { return nil }
        
        return getViewControllers()[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = getViewControllers().index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard getViewControllers().count != nextIndex else { return nil }
        guard getViewControllers().count > nextIndex else { return nil }
        
        return getViewControllers()[nextIndex]
    }

    // MARK: - PageDelegate methods
    
    func didFinish(viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - SongsPageViewController methods
    
    private func makeSongWithPageControlViewController(song: [String:Any], showDoneButton: Bool, numberOfPages: Int, currentPage: Int) -> UIViewController {
        let songWithPageControlViewController = SongWithPageControlViewController()
        
        songWithPageControlViewController.song = song
        songWithPageControlViewController.albumImageUrl = albumImageUrl
        songWithPageControlViewController.delegate = self
        songWithPageControlViewController.showDoneButton = showDoneButton
        songWithPageControlViewController.numberOfPages = numberOfPages
        songWithPageControlViewController.currentPage = currentPage
        
        return songWithPageControlViewController
    }
    
}
