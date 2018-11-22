//
//  SearchViewController.swift
//  Music
//
//  Created by Gary Davies on 22/11/18.
//  Copyright © 2018 Gary Davies. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // Mark: - Constants

    private static let subtitleTableViewCellIdentifier = "SubtitleTableViewCell"
    private static let apiRequestLimit = 20
    private static let resultsMax = 100
    
    // MARK: - Storyboard
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Dynmaic UI
    
    fileprivate var artistsTableView: UITableView!
    fileprivate var albumsTableView: UITableView!
    fileprivate var songsTableView: UITableView!
    
    // MARK: - Private variables
    
    fileprivate var searchText: String?
    fileprivate var artists: [[String:Any]] = []
    fileprivate var artistsPage = 1
    fileprivate var albums: [[String:Any]] = []
    fileprivate var albumsPage = 1
    fileprivate var songs: [[String:Any]] = []
    fileprivate var songsPage = 1

    // MARK: - Private backing variables
    
    fileprivate var stringUtility: StringUtility!
    fileprivate var dictionaryUtility: DictionaryUtility!
    fileprivate var arrayUtility: ArrayUtility!
    fileprivate var lastFmApi: LastFmApi!
    fileprivate var appColors: AppColors!
    
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
        
        // Prime LastFmAp with Last Fm api parameters
        let _ = getLastFmApi()
        
        view.backgroundColor = getAppColors().getBackgroundColor()
        var verticalPosition = searchBar.frame.origin.y + searchBar.frame.height
        var verticalSpaceLeft = view.frame.height - verticalPosition
        var tableViewHeight = verticalSpaceLeft / 3.0
        tableViewHeight = tableViewHeight.rounded()
        
        let artistsFrame = CGRect(origin: CGPoint(x: 0.0, y: verticalPosition), size: CGSize(width: view.frame.width, height: tableViewHeight))
        artistsTableView = UITableView(frame: artistsFrame, style: UITableViewStyle.plain)
        
        if artistsTableView != nil {
            artistsTableView?.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SearchViewController.subtitleTableViewCellIdentifier)
            artistsTableView?.delegate = self
            artistsTableView?.dataSource = self
            view.addSubview(artistsTableView!)
        }
        
        verticalPosition += tableViewHeight
        verticalSpaceLeft -= tableViewHeight
        
        let albumsFrame = CGRect(origin: CGPoint(x: 0.0, y: verticalPosition), size: CGSize(width: view.frame.width, height: tableViewHeight))
        albumsTableView = UITableView(frame: albumsFrame, style: UITableViewStyle.plain)
        
        if albumsTableView != nil {
            albumsTableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SearchViewController.subtitleTableViewCellIdentifier)
            albumsTableView.delegate = self
            albumsTableView.dataSource = self
            view.addSubview(albumsTableView)
        }
        
        verticalPosition += tableViewHeight
        verticalSpaceLeft -= tableViewHeight
        
        let songsFrame = CGRect(origin: CGPoint(x: 0.0, y: verticalPosition), size: CGSize(width: view.frame.width, height: verticalSpaceLeft))
        songsTableView = UITableView(frame: songsFrame, style: UITableViewStyle.plain)
        
        if songsTableView != nil {
            songsTableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: SearchViewController.subtitleTableViewCellIdentifier)
            songsTableView.delegate = self
            songsTableView.dataSource = self
            view.addSubview(songsTableView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UISerachBarDelegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        if artists.count > 0 {
            artists.removeAll()
            artistsTableView?.reloadData()
        }
        
        if albums.count > 0 {
            albums.removeAll()
            albumsTableView?.reloadData()
        }
        
        if songs.count > 0 {
            songs.removeAll()
            songsTableView?.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        if getStringUtility().hasValue(string: searchText) {
            artists.removeAll()
            artistsPage = 1
            searchArtists(artistSearchText: searchText!)
            searchAlbums(albumSearchText: searchText!)
            searchSongs(songSearchText: searchText!)
        }
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tableView) {
            case artistsTableView:
                return artists.count
            case albumsTableView:
                return albums.count
            case songsTableView:
                return songs.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var imageUrl: String?
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: SearchViewController.subtitleTableViewCellIdentifier, for: indexPath as IndexPath)
        
        if cell == nil {
            cell = SubtitleTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: SearchViewController.subtitleTableViewCellIdentifier)
        }
        
        switch(tableView) {
            case artistsTableView:
                let artist = artists[indexPath.row]
                let name = getDictionaryUtility().getString(dictionary: artist, key: "name")
                cell?.textLabel?.text = name
                let image = getDictionaryUtility().getArray(dictionary: artist, key: "image")
                
                if image != nil {
                    let small = getArrayUtility().getDictionaryByStringQuery(array: image!, key: "size", value: "small")
                    imageUrl = getDictionaryUtility().getString(dictionary: small, key: "#text")
                }
            case albumsTableView:
                let album = albums[indexPath.row]
                let name = getDictionaryUtility().getString(dictionary: album, key: "name")
                cell?.textLabel?.text = name
                let artist = getDictionaryUtility().getString(dictionary: album, key: "artist")
                cell?.detailTextLabel?.text = artist
                let image = getDictionaryUtility().getArray(dictionary: album, key: "image")
                
                if image != nil {
                    let small = getArrayUtility().getDictionaryByStringQuery(array: image!, key: "size", value: "small")
                    imageUrl = getDictionaryUtility().getString(dictionary: small, key: "#text")
                }
            case songsTableView:
                let song = songs[indexPath.row]
                let name = getDictionaryUtility().getString(dictionary: song, key: "name")
                cell?.textLabel?.text = name
                let artist = getDictionaryUtility().getString(dictionary: song, key: "artist")
                cell?.detailTextLabel?.text = artist
                let image = getDictionaryUtility().getArray(dictionary: song, key: "image")
                
                if image != nil {
                    let small = getArrayUtility().getDictionaryByStringQuery(array: image!, key: "size", value: "small")
                    imageUrl = getDictionaryUtility().getString(dictionary: small, key: "#text")
                }
            default:
                cell?.textLabel?.text = "---"
                cell?.detailTextLabel?.text = "second label"
        }
        
        cell?.imageView?.image = UIImage(named: "placeholder.png")
        cell?.layoutSubviews()
        
        if imageUrl != nil && cell != nil && cell?.imageView != nil {
            DispatchQueue.global(qos: .background).async {
                let lazyLoadImage = LazyLoadImage()
                lazyLoadImage.setUrl(url: imageUrl!)
                lazyLoadImage.setTableViewCell(tableViewCell: cell!)
                lazyLoadImage.load()
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(tableView) {
            case artistsTableView:
                return "Artists"
            case albumsTableView:
                return "Albums"
            case songsTableView:
                return "Songs"
            default:
                return "---"
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(tableView) {
            case artistsTableView:
                let mbid = getDictionaryUtility().getString(dictionary: artists[indexPath.row], key: "mbid")
                
                if getStringUtility().hasValue(string: mbid) {
                    let artistInfoViewController = ArtistInfoViewController()
                    artistInfoViewController.artistMbid = mbid
                    present(artistInfoViewController, animated: true, completion: nil)
                } else {
                    showAlert(message: "This artist is not available")
                }
            case albumsTableView:
                let mbid = getDictionaryUtility().getString(dictionary: albums[indexPath.row], key: "mbid")
                
                if getStringUtility().hasValue(string: mbid) {
                    let albumInfoViewController = AlbumInfoViewController()
                    albumInfoViewController.albumMbid = mbid
                    present(albumInfoViewController, animated: true, completion: nil)
                } else {
                    showAlert(message: "This album is not available")
                }
            case songsTableView:
                let mbid = getDictionaryUtility().getString(dictionary: songs[indexPath.row], key: "mbid")
                
                if getStringUtility().hasValue(string: mbid) {
                    let songInfoViewController = SongInfoViewController()
                    songInfoViewController.songMbid = mbid
                    present(songInfoViewController, animated: true, completion: nil)
                } else {
                    showAlert(message: "This song is not available")
                }
            default:
                print("unknown TableView didSelectRowAt ", indexPath)
        }
    }
    
    // MARK: - SerachViewController methods
    
    fileprivate func searchArtists(artistSearchText: String) {
        guard getStringUtility().areEqual(string: artistSearchText, other: searchText) else { return }
        
        DispatchQueue.global(qos: .background).async {
            var parameters: [String:Any] = [:]
            parameters["method"] = "artist" as Any
            parameters["search"] = artistSearchText as Any
            parameters["limit"] = SearchViewController.apiRequestLimit as Any
            parameters["page"] = self.artistsPage as Any
            self.getLastFmApi().search(parameters: parameters) { (response) in
                DispatchQueue.main.async {
                    
                    if let response = response {
                        self.acceptSearchArtistsResponse(artistSearchText: artistSearchText, response: response)
                    }
                }
            }
        }
    }
    
    fileprivate func acceptSearchArtistsResponse(artistSearchText: String, response: [String:Any]) {
        guard getStringUtility().areEqual(string: artistSearchText, other: searchText) else { return }
        
        let content = getDictionaryUtility().getDictionary(dictionary: response, key: "content")
        let results = getDictionaryUtility().getDictionary(dictionary: content, key: "results")
        let artistmatches = getDictionaryUtility().getDictionary(dictionary: results, key: "artistmatches")
        let artist = getDictionaryUtility().getArray(dictionary: artistmatches, key: "artist")
        
        if artist != nil {
            var index = 0
            var indexPaths: [IndexPath] = []
            
            while (index < (artist?.count)! && index < SearchViewController.apiRequestLimit) {
                if let artistDictionary = artist?[index] as? [String:Any] {
                    artists.append(artistDictionary)
                    index += 1
                    indexPaths.append(IndexPath(item: artists.count - 1, section: 0))
                }
            }
            
            artistsTableView?.insertRows(at: indexPaths, with: .automatic)
            
            if (artist?.count)! >= SearchViewController.apiRequestLimit && artists.count < SearchViewController.resultsMax {
                albumsPage += 1
                searchArtists(artistSearchText: artistSearchText)
            }
        }
    }
    
    fileprivate func searchAlbums(albumSearchText: String) {
        guard getStringUtility().areEqual(string: albumSearchText, other: searchText) else { return }

        DispatchQueue.global(qos: .background).async {
            var parameters: [String:Any] = [:]
            parameters["method"] = "album" as Any
            parameters["search"] = albumSearchText as Any
            parameters["limit"] = SearchViewController.apiRequestLimit as Any
            parameters["page"] = self.albumsPage as Any
            self.getLastFmApi().search(parameters: parameters) { (response) in
                DispatchQueue.main.async {
                    
                    if let response = response {
                        self.acceptSearchAlbumsResponse(albumSearchText: albumSearchText, response: response)
                    }
                }
            }
        }
    }
    
    fileprivate func acceptSearchAlbumsResponse(albumSearchText: String, response: [String:Any]) {
        guard getStringUtility().areEqual(string: albumSearchText, other: searchText) else { return }
        
        let content = getDictionaryUtility().getDictionary(dictionary: response, key: "content")
        let results = getDictionaryUtility().getDictionary(dictionary: content, key: "results")
        let albummatches = getDictionaryUtility().getDictionary(dictionary: results, key: "albummatches")
        let album = getDictionaryUtility().getArray(dictionary: albummatches, key: "album")
        
        if album != nil {
            var index = 0
            var indexPaths: [IndexPath] = []
            
            while (index < (album?.count)! && index < SearchViewController.apiRequestLimit) {
                
                if let albumDictionary = album?[index] as? [String:Any] {
                    albums.append(albumDictionary)
                    index += 1
                    indexPaths.append(IndexPath(item: albums.count - 1, section: 0))
                }
            }
            
            albumsTableView?.insertRows(at: indexPaths, with: .automatic)
            
            if (album?.count)! >= SearchViewController.apiRequestLimit && albums.count < SearchViewController.resultsMax {
                albumsPage += 1
                searchAlbums(albumSearchText: albumSearchText)
            }
        }
    }

    fileprivate func searchSongs(songSearchText: String) {
        guard getStringUtility().areEqual(string: songSearchText, other: searchText) else { return }
        
        DispatchQueue.global(qos: .background).async {
            var parameters: [String:Any] = [:]
            parameters["method"] = "track" as Any
            parameters["search"] = songSearchText as Any
            parameters["limit"] = SearchViewController.apiRequestLimit as Any
            parameters["page"] = self.songsPage as Any
            self.getLastFmApi().search(parameters: parameters) { (response) in
                DispatchQueue.main.async {
                    
                    if let response = response {
                        self.acceptSearchSongsResponse(songSearchText: songSearchText, response: response)
                    }
                }
            }
        }
    }
    
    fileprivate func acceptSearchSongsResponse(songSearchText: String, response: [String:Any]) {
        guard getStringUtility().areEqual(string: songSearchText, other: searchText) else {
            return
        }
        
        let content = getDictionaryUtility().getDictionary(dictionary: response, key: "content")
        let results = getDictionaryUtility().getDictionary(dictionary: content, key: "results")
        let trackmatches = getDictionaryUtility().getDictionary(dictionary: results, key: "trackmatches")
        let song = getDictionaryUtility().getArray(dictionary: trackmatches, key: "track")
        
        if song != nil {
            var index = 0
            var indexPaths: [IndexPath] = []
            
            while (index < (song?.count)! && index < SearchViewController.apiRequestLimit) {
                
                if let songDictionary = song?[index] as? [String:Any] {
                    songs.append(songDictionary)
                    index += 1
                    indexPaths.append(IndexPath(item: songs.count - 1, section: 0))
                }
            }
            songsTableView?.insertRows(at: indexPaths, with: .automatic)
            
            if (song?.count)! >= SearchViewController.apiRequestLimit && songs.count < SearchViewController.resultsMax {
                songsPage += 1
                searchSongs(songSearchText: songSearchText)
            }
        }
    }

    fileprivate func showAlert(message: String) {
        let alert = UIAlertController(title: "last.fm", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
