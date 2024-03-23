//
//  HomeCollectionViewCell.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 16/02/24.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var artistName: UILabel!
    
    fileprivate func updateDataWith(_ artist: Artist) {
        self.artistName.text = artist.name
    }
}

extension HomeCollectionViewCell {
    class func buildIn(_ collectionView: UICollectionView, in indexPath: IndexPath, with car: Artist) -> HomeCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        cell?.updateDataWith(car)

        return cell ?? HomeCollectionViewCell()
    }
}
