//
//  TopTracksViewController.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 19/02/24.
//

import UIKit

class TopTracksViewController: UIViewController {
    var artist: Artist?
    var topTracksView: TopTracksViewProtocol? {
        self.view as? TopTracksViewProtocol
    }
    lazy var webService = SpotifyWS()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topTracksView?.setDelegates()
        self.topTracksView?.setFlowLayout()
        self.topTracksView?.setArtistImage(self.artist?.images[0].url ?? "")
        self.getTopTracksByArtist()
    }
    
    func getTopTracksByArtist() {
        self.webService.retrieveToken() { response in
            self.webService.getTopTrackByArtist(accessToken: response.access_token ?? "", artistId: self.artist?.id ?? "") { topTracksResponse in
                guard let topTracksResponseList = topTracksResponse.tracks else { return }
                self.topTracksView?.setDataSource(topTracksResponseList.toList.filterByPreviewURL)
            }
        }
    }
}

extension TopTracksViewController: TopTracksViewDelegate {
    func topTracksViewDidTapOnCollectionViewCell(_ topTracksView: TopTracksView, soundURL: String, row: Int) {
        self.topTracksView?.playSoundWithUrl(soundURL, andUpdateRow: row)
    }
}

