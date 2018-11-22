//
//  AlbumWithPageControlViewController.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class AlbumWithPageControlViewController: UIViewController {
    
    // MARK: - public variables
    
    var album: [String:Any]?
    var delegate: PageDelegate?
    var numberOfPages: Int?
    var currentPage: Int?
    var showDoneButton: Bool?

    // MARK: - Private variables

    fileprivate var albumUrl: String?

    // MARK: - Private backing variables
    
    fileprivate var appColors: AppColors!
    fileprivate var stringUtility: StringUtility!
    fileprivate var dictionaryUtility: DictionaryUtility!
    fileprivate var arrayUtility: ArrayUtility!
    
    // MARK: - Setters and getters
    
    private func getStringUtility() -> StringUtility {
        if stringUtility != nil {
            return stringUtility
        }
        
        stringUtility = StringUtility()
        
        return stringUtility
    }
    
    private func getDictionaryUtility() -> DictionaryUtility {
        if dictionaryUtility != nil {
            return dictionaryUtility
        }
        
        dictionaryUtility = DictionaryUtility()
        
        return dictionaryUtility
    }
    
    private func getArrayUtility() -> ArrayUtility {
        if arrayUtility != nil {
            return arrayUtility
        }
        
        arrayUtility = ArrayUtility()
        
        return arrayUtility
    }
    
    private func getAppColors() -> AppColors {
        if appColors != nil {
            return appColors
        }
        
        appColors = AppColors()
        
        return appColors
    }
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = getAppColors().getBackgroundColor()
        
        addPageControl()
        addBackButton()
        addAlbumImage()
        addAlbumTitle()
        addArtistTitle()
        addAlbumUrl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AlbumWithPageCountrolViewController methods
    
    fileprivate func addBackButton() {
        let button = UIButton(frame: CGRect(x: 10, y: 30, width: 50, height: 30))
        button.setTitle("Back", for: [.normal])
        button.setTitleColor(getAppColors().getLightTextColor(), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.backgroundColor = getAppColors().getButtonColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = getAppColors().getBorderColor().cgColor
        self.view.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        delegate?.didFinish(viewController: self)
    }
    
    fileprivate func addAlbumImage() {
        var imageUrl: String?
        let image = getDictionaryUtility().getArray(dictionary: album, key: "image")
        
        if image != nil {
            let small = getArrayUtility().getDictionaryByStringQuery(array: image!, key: "size", value: "extralarge")
            imageUrl = getDictionaryUtility().getString(dictionary: small, key: "#text")
        }

        let size = view.frame.width * 0.8
        let imageView = UIImageView(frame: CGRect(x: view.frame.width * 0.1, y: 80, width: size, height: size))
        view.addSubview(imageView)
        
        if getStringUtility().hasValue(string: imageUrl) {
            DispatchQueue.global(qos: .background).async {
                let lazyLoadImage = LazyLoadImage()
                lazyLoadImage.setUrl(url: imageUrl!)
                lazyLoadImage.setImageView(imageView: imageView)
                lazyLoadImage.load()
            }
        }
    }
    
    fileprivate func addArtistTitle() {
        let artist = getDictionaryUtility().getDictionary(dictionary: album, key: "artist")
        let name = getDictionaryUtility().getString(dictionary: artist, key: "name")
        let label = UILabel(frame: CGRect(x: 0.0, y: 400.0, width: view.frame.width, height: 20.0))
        label.text = name
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = getAppColors().getDarkTextColor()
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    fileprivate func addAlbumTitle() {
        let name = getDictionaryUtility().getString(dictionary: album, key: "name")
        let label = UILabel(frame: CGRect(x: 0.0, y: 450.0, width: view.frame.width, height: 20.0))
        label.text = name
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = getAppColors().getDarkTextColor()
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    fileprivate func addAlbumUrl() {
        albumUrl = getDictionaryUtility().getString(dictionary: album, key: "url")
        if getStringUtility().hasValue(string: albumUrl) {
            let label = UILabel(frame: CGRect(x: view.frame.width * 0.1, y: 500.0, width: view.frame.width * 0.8, height: 20.0))
            label.textAlignment = .center
            label.text = "www.last.fm"
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.textColor = getAppColors().getDarkTextColor()
            
            let underlineAttriString = NSAttributedString(string:"www.last.fm", attributes:
                [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
            label.attributedText = underlineAttriString
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(urlTap))
            label.addGestureRecognizer(tap)
            view.addSubview(label)
        }
        
    }
    
    @objc func urlTap(sender:UITapGestureRecognizer) {
        if let albumUrl = albumUrl {
            guard getStringUtility().hasValue(string: albumUrl) else { return }
            guard let url = URL(string: albumUrl) else { return }
            
            UIApplication.shared.open(url)
        }
    }

    fileprivate func addPageControl() {
        let pageControl = UIPageControl(frame: CGRect(x: view.frame.width * 0.2, y: view.frame.height - 60.0, width: view.frame.width * 0.6, height: 30.0))
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
        
        if let numberOfPages = numberOfPages {
            pageControl.numberOfPages = numberOfPages
        }
        
        if let currentPage = currentPage {
            pageControl.currentPage = currentPage
        }
    }

}
