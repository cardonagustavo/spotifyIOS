//
//  TopTracksCollectionViewCell.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 19/02/24.
//

import UIKit

class TopTracksCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var playIcon: UIImageView!
    
    fileprivate func updateDataWith(_ track: Track) {
        self.trackName.text = track.name
        self.artistName.text = track.albums.artists?[0].name
        if track.isPlatying {
            self.trackName.textColor = UIColor(red: 0.13, green: 0.84, blue: 0.38, alpha: 1.00)
            self.playIcon.image = UIImage(systemName: "pause.circle.fill")
        } else {
            self.trackName.textColor = .white
            self.playIcon.image = UIImage(systemName: "play.circle.fill")
        }
    }
}

extension TopTracksCollectionViewCell {
    class func buildIn(_ collectionView: UICollectionView, in indexPath: IndexPath, with track: Track) -> TopTracksCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topTrackViewCell", for: indexPath) as? TopTracksCollectionViewCell
        cell?.updateDataWith(track)

        return cell ?? TopTracksCollectionViewCell()
    }
}
