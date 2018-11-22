//
//  SongInfoViewController.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class SongInfoViewController: UIViewController {
    
    // MARK: - public variables
    
    var songMbid: String?
    
    // MARK: - private variables
    
    fileprivate var artistMbid: String?
    fileprivate var albumMbid: String?
    fileprivate var artistName: String?
    fileprivate var albumTitle: String?
    fileprivate var albumImageUrl: String?
    fileprivate var songUrl: String?
    fileprivate var name: String?
    fileprivate var playCount: String?
    fileprivate var listeners: String?

    fileprivate var wikiContent: String?
    fileprivate var wikiSummary: String?
    fileprivate var wikiPublished: String?
    
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
        getSongInfo()
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

    fileprivate func getSongInfo() {
        DispatchQueue.global(qos: .background).async {
            var parameters: [String:Any] = [:]
            parameters["method"] = "track" as Any
            parameters["mbid"] = self.songMbid as Any
            self.getLastFmApi().getInfo(parameters: parameters) { (response) in
                
                if let response = response {
                    self.acceptSongInfoResponse(response: response)
                }
            }
        }
    }
    
    fileprivate func acceptSongInfoResponse(response: [String:Any]) {
        let content = getDictionaryUtility().getDictionary(dictionary: response, key: "content")
        let track = getDictionaryUtility().getDictionary(dictionary: content, key: "track")
        
        guard track != nil else { return }
        
        name = getDictionaryUtility().getString(dictionary: track, key: "name")
        let artist = getDictionaryUtility().getDictionary(dictionary: track, key: "artist")
        artistName = getDictionaryUtility().getString(dictionary: artist, key: "name")
        artistMbid = getDictionaryUtility().getString(dictionary: artist, key: "mbid")
        let album = getDictionaryUtility().getDictionary(dictionary: track, key: "album")
        albumMbid = getDictionaryUtility().getString(dictionary: album, key: "mbid")
        albumTitle = getDictionaryUtility().getString(dictionary: album, key: "title")
        let image = getDictionaryUtility().getArray(dictionary: album, key: "image")
        
        if image != nil {
            let extralarge = getArrayUtility().getDictionaryByStringQuery(array: image!, key: "size", value: "extralarge")
            albumImageUrl = getDictionaryUtility().getString(dictionary: extralarge, key: "#text")
        }
        
        songUrl = getDictionaryUtility().getString(dictionary: track, key: "url")
        playCount = getDictionaryUtility().getString(dictionary: track, key: "playcount")
        listeners = getDictionaryUtility().getString(dictionary: track, key: "listeners")
        let wiki = getDictionaryUtility().getDictionary(dictionary: track, key: "wiki")
        
        if let wiki = wiki {
            wikiContent = getDictionaryUtility().getString(dictionary: wiki, key: "content")
            wikiSummary = getDictionaryUtility().getString(dictionary: wiki, key: "summary")
            wikiPublished = getDictionaryUtility().getString(dictionary: wiki, key: "published")
            print("wiki keys", wiki.keys)
        }
        
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    fileprivate func updateUI() {
        addImage()
        addArtistTitle()
        addAlbumTitle()
        addSongName()
        addPlayCountListenersAndPublished()
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

    fileprivate func addArtistTitle() {
        let label = UILabel(frame: CGRect(x: 0.0, y: 390.0, width: view.frame.width, height: 20.0))
        label.text = artistName
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = getAppColors().getDarkTextColor()
        label.textAlignment = .center
        view.addSubview(label)
    }

    fileprivate func addAlbumTitle() {
        let label = UILabel(frame: CGRect(x: 0.0, y: 420.0, width: view.frame.width, height: 20.0))
        label.text = albumTitle
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = getAppColors().getDarkTextColor()
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    fileprivate func addSongName() {
        let label = UILabel(frame: CGRect(x: 0.0, y: 450.0, width: view.frame.width, height: 20.0))
        label.text = name
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = getAppColors().getDarkTextColor()
        label.textAlignment = .center
        view.addSubview(label)
    }

    fileprivate func addPlayCountListenersAndPublished() {
        if let playCount = playCount, let listeners = listeners, let wikiPublished = wikiPublished {
            let label = UILabel(frame: CGRect(x: view.frame.width * 0.02, y: 480.0, width: view.frame.width * 0.96, height: 20.0))
            label.text = String(format: "Play Count %@   Listeners %@   %@", playCount, listeners, wikiPublished)
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textColor = getAppColors().getDarkTextColor()
            view.addSubview(label)
        }
    }

    fileprivate func addUrl() {
        guard let songUrl = songUrl else { return }

        let label = UILabel(frame: CGRect(x: view.frame.width * 0.02, y: 500.0, width: view.frame.width * 0.96, height: 20.0))
        label.text = songUrl
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = getAppColors().getDarkTextColor()
        
        let underlineAttriString = NSAttributedString(string:songUrl, attributes:
            [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        label.attributedText = underlineAttriString
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(urlTap))
        label.addGestureRecognizer(tap)
        view.addSubview(label)
    }

    @objc func urlTap(sender:UITapGestureRecognizer) {
        guard getStringUtility().hasValue(string: songUrl) else { return }
        guard let url = URL(string: songUrl!) else { return }
        
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
