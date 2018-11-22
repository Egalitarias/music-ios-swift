//
//  AlbumInfoViewController.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class AlbumInfoViewController: UIViewController {
    
    // MARK: - public variables
    
    var albumMbid: String?
    
    // MARK: - private variables
    
    fileprivate var artistMbid: String?
    fileprivate var artistName: String?
    fileprivate var albumName: String?
    fileprivate var albumImageUrl: String?
    fileprivate var albumUrl: String?
    fileprivate var name: String?
    fileprivate var playCount: String?
    fileprivate var listeners: String?
    
    fileprivate var wikiContent: String?
    fileprivate var wikiSummary: String?
    fileprivate var wikiPublished: String?
    
    fileprivate var songs: [[String:Any]] = []

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
        addSongsButton()
        getAlbumInfo()
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

    fileprivate func addSongsButton() {
        let button = UIButton(frame: CGRect(x: view.frame.width - 10.0 - 80.0, y: 30.0, width: 80.0, height: 30.0))
        button.setTitle("Songs", for: [.normal])
        button.setTitleColor(getAppColors().getLightTextColor(), for: .normal)
        button.addTarget(self, action: #selector(songButtonTouchUpInside), for: .touchUpInside)
        button.backgroundColor = getAppColors().getButtonColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = getAppColors().getBorderColor().cgColor
        self.view.addSubview(button)
    }
    
    @objc func songButtonTouchUpInside(sender: UIButton!) {
        let songsPageViewController = SongsPageViewController()
        songsPageViewController.songs = songs
        songsPageViewController.albumImageUrl = albumImageUrl
        present(songsPageViewController, animated: true, completion: nil)
    }

    fileprivate func getAlbumInfo() {
        DispatchQueue.global(qos: .background).async {
            var parameters: [String:Any] = [:]
            parameters["method"] = "album" as Any
            parameters["mbid"] = self.albumMbid as Any
            self.getLastFmApi().getInfo(parameters: parameters) { (response) in
                
                if let response = response {
                    self.acceptAlbumInfoResponse(response: response)
                }
            }
        }
    }
    
    fileprivate func acceptAlbumInfoResponse(response: [String:Any]) {
        let content = getDictionaryUtility().getDictionary(dictionary: response, key: "content")
        let album = getDictionaryUtility().getDictionary(dictionary: content, key: "album")
        
        guard album != nil else { return }
        
        artistName = getDictionaryUtility().getString(dictionary: album, key: "artist")
        albumName = getDictionaryUtility().getString(dictionary: album, key: "name")
        playCount = getDictionaryUtility().getString(dictionary: album, key: "playcount")
        listeners = getDictionaryUtility().getString(dictionary: album, key: "listeners")
        albumUrl = getDictionaryUtility().getString(dictionary: album, key: "url")
        let image = getDictionaryUtility().getArray(dictionary: album, key: "image")
        
        if image != nil {
            let extralarge = getArrayUtility().getDictionaryByStringQuery(array: image!, key: "size", value: "extralarge")
            albumImageUrl = getDictionaryUtility().getString(dictionary: extralarge, key: "#text")
        }
        
        let wiki = getDictionaryUtility().getDictionary(dictionary: album, key: "wiki")
        
        if let wiki = wiki {
            wikiContent = getDictionaryUtility().getString(dictionary: wiki, key: "content")
            wikiSummary = getDictionaryUtility().getString(dictionary: wiki, key: "summary")
            wikiPublished = getDictionaryUtility().getString(dictionary: wiki, key: "published")
        }
        
        let tracks = getDictionaryUtility().getDictionary(dictionary: album, key: "tracks")
        let track = getDictionaryUtility().getArray(dictionary: tracks, key: "track")
        
        if let track = track {
            
            if track.count > 0 {
                
                if let firstTrack = track.first as? [String:Any] {
                    
                    let artist = getDictionaryUtility().getDictionary(dictionary: firstTrack, key: "artist")
                    artistMbid = getDictionaryUtility().getString(dictionary: artist, key: "mbid")
                }
                
                for song in track {
                    
                    if let song = song as? [String:Any] {
                        songs.append(song)
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    fileprivate func updateUI() {
        addImage()
        addArtistName()
        addAlbumName()
        addPlayCountAndListeners()
        addUrl()
        addSummary()
    }
    
    fileprivate func addImage() {
        let size = view.frame.width * 0.8
        let imageView = UIImageView(frame: CGRect(x: view.frame.width * 0.1, y: 80, width: size, height: size))
        view.addSubview(imageView)
        
        if getStringUtility().hasValue(string: albumImageUrl) {
            
            DispatchQueue.global(qos: .background).async {
                let lazyLoadImage = LazyLoadImage()
                lazyLoadImage.setUrl(url: self.albumImageUrl!)
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
    
    fileprivate func addAlbumName() {
        let label = UILabel(frame: CGRect(x: 0.0, y: 420.0, width: view.frame.width, height: 20.0))
        label.text = albumName
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
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
        guard let albumUrl = albumUrl else { return }
        
        let label = UILabel(frame: CGRect(x: view.frame.width * 0.02, y: 470.0, width: view.frame.width * 0.96, height: 20.0))
        label.text = albumUrl
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = getAppColors().getDarkTextColor()
        
        let underlineAttriString = NSAttributedString(string:albumUrl, attributes:
            [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        label.attributedText = underlineAttriString
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(urlTap))
        label.addGestureRecognizer(tap)
        view.addSubview(label)
    }
    
    @objc func urlTap(sender:UITapGestureRecognizer) {
        guard getStringUtility().hasValue(string: albumUrl) else {
            return
        }
        guard let url = URL(string: albumUrl!) else { return }
        
        UIApplication.shared.open(url)
    }
    
    fileprivate func addSummary() {
        if let wikiSummary = wikiSummary {
            let label = UILabel(frame: CGRect(x: view.frame.width * 0.02, y: 490.0, width: view.frame.width * 0.96, height: 200.0))
            label.text = getStringUtility().removeHtmlTag(string: wikiSummary, tag: "a")
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 10
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textColor = getAppColors().getDarkTextColor()
            view.addSubview(label)
        }
        
    }

}
