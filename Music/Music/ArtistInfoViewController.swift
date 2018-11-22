//
//  ArtistInfoViewController.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class ArtistInfoViewController: UIViewController {
    
    // MARK: - public variables
    
    var artistMbid: String?
    
    // MARK: - private variables
    
    fileprivate var artistName: String?
    fileprivate var artistImageUrl: String?
    fileprivate var artistUrl: String?
    fileprivate var name: String?
    fileprivate var playCount: String?
    fileprivate var listeners: String?
    
    fileprivate var bioContent: String?
    fileprivate var bioSummary: String?
    fileprivate var bioPublished: String?
    
    fileprivate var albums: [Any] = []
    
    // MARK: - Private backing variables
    
    fileprivate var stringUtility: StringUtility!
    fileprivate var dictionaryUtility: DictionaryUtility!
    fileprivate var arrayUtility: ArrayUtility!
    fileprivate var appColors: AppColors!
    fileprivate var lastFmApi: LastFmApi!
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        // Prime LastFmAp with Last Fm api parameters
        let _ = getLastFmApi()

        view.backgroundColor = getAppColors().getBackgroundColor()
        
        addBackButton()
        addAlbumsButton()
        getArtistInfo()
        getArtistTopAlbums()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SingInfoViewController methods
    
    fileprivate func addBackButton() {
        let button = UIButton(frame: CGRect(x: 10.0, y: 30.0, width: 80.0, height: 30.0))
        button.setTitle("Back", for: [.normal])
        button.setTitleColor(getAppColors().getLightTextColor(), for: .normal)
        button.addTarget(self, action: #selector(backButtonTouchUpInside), for: .touchUpInside)
        button.backgroundColor = getAppColors().getButtonColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = getAppColors().getBorderColor().cgColor
        self.view.addSubview(button)
    }
    
    @objc func backButtonTouchUpInside(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }

    fileprivate func addAlbumsButton() {
        let button = UIButton(frame: CGRect(x: view.frame.width - 10.0 - 80.0, y: 30.0, width: 80.0, height: 30.0))
        button.setTitle("Albums", for: [.normal])
        button.setTitleColor(getAppColors().getLightTextColor(), for: .normal)
        button.addTarget(self, action: #selector(albumsButtonTouchUpInside), for: .touchUpInside)
        button.backgroundColor = getAppColors().getButtonColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = getAppColors().getBorderColor().cgColor
        self.view.addSubview(button)
    }
    
    @objc func albumsButtonTouchUpInside(sender: UIButton!) {
        if albums.count == 0 {
            showAlert(message: "Albums are not avaible, try again later")
            
            return
        }
        
        let albumsPageViewController = AlbumsPageViewController()
        albumsPageViewController.artistMbid = artistMbid
        albumsPageViewController.albums.removeAll()
        
        for album in albums {
            if let albumDictionary = album as? [String:Any] {
                albumsPageViewController.albums.append(albumDictionary)
            }
        }
        
        present(albumsPageViewController, animated: true, completion: nil)
    }

    fileprivate func getArtistInfo() {
        DispatchQueue.global(qos: .background).async {
            var parameters: [String:Any] = [:]
            parameters["method"] = "artist" as Any
            parameters["mbid"] = self.artistMbid as Any
            self.getLastFmApi().getInfo(parameters: parameters) { (response) in
                
                if let response = response {
                    self.acceptArtistInfoResponse(response: response)
                }
            }
        }
    }
    
    fileprivate func acceptArtistInfoResponse(response: [String:Any]) {
        let content = getDictionaryUtility().getDictionary(dictionary: response as [String : AnyObject], key: "content")
        let artist = getDictionaryUtility().getDictionary(dictionary: content, key: "artist")
        
        guard artist != nil else { return }
        
        artistName = getDictionaryUtility().getString(dictionary: artist, key: "name")
        let stats = getDictionaryUtility().getDictionary(dictionary: artist, key: "stats")
        playCount = getDictionaryUtility().getString(dictionary: stats, key: "playcount")
        listeners = getDictionaryUtility().getString(dictionary: stats, key: "listeners")
        artistUrl = getDictionaryUtility().getString(dictionary: artist, key: "url")
        let image = getDictionaryUtility().getArray(dictionary: artist, key: "image")
        
        if image != nil {
            let extralarge = getArrayUtility().getDictionaryByStringQuery(array: image!, key: "size", value: "extralarge")
            artistImageUrl = getDictionaryUtility().getString(dictionary: extralarge, key: "#text")
        }
        
        let bio = getDictionaryUtility().getDictionary(dictionary: artist, key: "bio")
        
        if let bio = bio {
            bioContent = getDictionaryUtility().getString(dictionary: bio, key: "content")
            bioSummary = getDictionaryUtility().getString(dictionary: bio, key: "summary")
            bioPublished = getDictionaryUtility().getString(dictionary: bio, key: "published")
        }
        
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    fileprivate func getArtistTopAlbums() {
        DispatchQueue.global(qos: .background).async {
            var parameters: [String:Any] = [:]
            parameters["mbid"] = self.artistMbid as Any
            parameters["limit"] = 10 as Any
            self.getLastFmApi().getTopAlbums(parameters: parameters) { (response) in
                
                if let response = response {
                    self.acceptArtistTopAlbumsResponse(response: response)
                }
            }
        }
    }

    fileprivate func acceptArtistTopAlbumsResponse(response: [String:Any]) {
        let content = getDictionaryUtility().getDictionary(dictionary: response as [String : AnyObject], key: "content")
        
        let topalbums = getDictionaryUtility().getDictionary(dictionary: content, key: "topalbums")
        
        guard topalbums != nil else { return }

        let album = getDictionaryUtility().getArray(dictionary: topalbums, key: "album")

        guard album != nil else { return }
        
        albums = album!
    }

    fileprivate func updateUI() {
        addImage()
        addArtistName()
        addPlayCountAndListeners()
        addUrl()
        addSummary()
    }
    
    fileprivate func addImage() {
        let size = view.frame.width * 0.8
        let imageView = UIImageView(frame: CGRect(x: view.frame.width * 0.1, y: 80, width: size, height: size))
        view.addSubview(imageView)
        
        if getStringUtility().hasValue(string: artistImageUrl) {
            DispatchQueue.global(qos: .background).async {
                let lazyLoadImage = LazyLoadImage()
                lazyLoadImage.setUrl(url: self.artistImageUrl!)
                lazyLoadImage.setImageView(imageView: imageView)
                lazyLoadImage.load()
            }
        }
    }
    
    fileprivate func addArtistName() {
        let label = UILabel(frame: CGRect(x: 0.0, y: 390.0, width: view.frame.width, height: 20.0))
        label.text = artistName
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = getAppColors().getDarkTextColor()
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    fileprivate func addPlayCountAndListeners() {
        if let playCount = playCount, let listeners = listeners {
            let label = UILabel(frame: CGRect(x: view.frame.width * 0.02, y: 450.0, width: view.frame.width * 0.96, height: 20.0))
            label.text = String(format: "Play Count %@   Listeners %@", playCount, listeners)
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textColor = getAppColors().getDarkTextColor()
            view.addSubview(label)
        }
    }
    
    fileprivate func addUrl() {
        guard let artistUrl = artistUrl else { return }
        
        let label = UILabel(frame: CGRect(x: view.frame.width * 0.02, y: 470.0, width: view.frame.width * 0.96, height: 20.0))
        label.text = artistUrl
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = getAppColors().getDarkTextColor()
        
        let underlineAttriString = NSAttributedString(string:artistUrl, attributes:
            [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        label.attributedText = underlineAttriString
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(urlTap))
        label.addGestureRecognizer(tap)
        view.addSubview(label)
    }
    
    @objc func urlTap(sender:UITapGestureRecognizer) {
        guard getStringUtility().hasValue(string: artistUrl) else { return }
        guard let url = URL(string: artistUrl!) else { return }
        
        UIApplication.shared.open(url)
    }
    
    fileprivate func addSummary() {
        if let bioSummary = bioSummary {
            let label = UILabel(frame: CGRect(x: view.frame.width * 0.02, y: 500.0, width: view.frame.width * 0.96, height: 150.0))
            label.text = getStringUtility().removeHtmlTag(string: bioSummary, tag: "a")
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 15
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textColor = getAppColors().getDarkTextColor()
            view.addSubview(label)
        }
    }
    
    fileprivate func showAlert(message: String) {
        let alert = UIAlertController(title: "last.fm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
