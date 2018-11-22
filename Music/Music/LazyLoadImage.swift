//
//  LazyLoadImage.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class LazyLoadImage {
    
    fileprivate weak var tableViewCell: UITableViewCell?
    fileprivate weak var imageView: UIImageView?
    fileprivate var url: String?
    
    func setTableViewCell(tableViewCell: UITableViewCell) {
        self.tableViewCell = tableViewCell
    }
    
    func setImageView(imageView: UIImageView) {
        self.imageView = imageView
    }

    func setUrl(url: String) {
        self.url = url
    }
    
    func load() {
        guard url != nil else { return }
        
        let lastFmApi = LastFmApi()
        lastFmApi.downloadData(url: url!) { (data) in
            
            if data != nil {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.tableViewCell?.imageView?.image = image
                    self.tableViewCell?.layoutSubviews()
                    self.imageView?.image = image
                }
            }
        }
    }
}
