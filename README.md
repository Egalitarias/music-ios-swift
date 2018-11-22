# Last Fm #

Develop a last.fm search mobile app

## Features ##

* The user must be able to search within the mobile app for either an Artist, album or song with the API provided (At the same time)
* Each keyboard Stroke must trigger a search through the three calls
* Swift Mandatory
* Cells must load 20 results initially and continue loading results upon user scroll down to the bottom not before.
* The user will be able to select the cell with will show all the information about the item and provide specified links to the artist or album page.
* If the user clicks on an artist (while on a song or album) The app must present a view with the artist info.

## MVP (Minimum Viable Product) ##

* Utilize programming best practices and good architecture/design decisions as you
see fit.
* Show the search results to the user divided in sections (Artists, albums, songs).
* If the song, artist or album has artwork should be displayed on the cell along with the
name and use the subtitle too:  Ex: Title: OK Computer subtitle: Radiohead….
* Show info about the Artist, album or song, and any artwork available (if several,
swipe to move from one to the next.) on a Detail View.
* App Should use Swift
* App should be uploaded to an online Git Repository for version control.
* Credit any and all Third Party Libraries.

## API ##

* Sign-up for a last.fm account at http://last.fm
* Go to: https://www.last.fm.api/account/create
* Album search https://www.last.fm/api/show/album.search

### Sample API ###

* http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=cher&api_key=YOUR_API_KEY&format=json
* http://ws.audioscrobbler.com/2.0/?method=album.search&album=believe&api_key=YOUR_API_KEY&format=json
* http://ws.audioscrobbler.com/2.0/?method=track.search&track=Believe&api_key=YOUR_API_KEY&format=json

### Artist ###

* limit (Optional) : The number of results to fetch per page. Defaults to 30.
* page (Optional) : The page number to fetch. Defaults to first page.
* artist (Required) : The artist name
* api_key (Required) : A Last.fm API key.

### Album ###

* limit (Optional) : The number of results to fetch per page. Defaults to 30.
* page (Optional) : The page number to fetch. Defaults to first page.
* album (Required) : The album name
* api_key (Required) : A Last.fm API key.

### Track ###
* limit (Optional) : The number of results to fetch per page. Defaults to 30.
* page (Optional) : The page number to fetch. Defaults to first page.
* track (Required) : The track name
* artist (Optional) : Narrow your search by specifying an artist.
* api_key (Required) : A Last.fm API key.
