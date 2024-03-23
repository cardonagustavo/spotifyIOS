//
//  TopTracksView.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 19/02/24.
//

import UIKit
import AVFoundation

protocol TopTracksViewProtocol {
    func setFlowLayout()
    func setDataSource(_ dataSource: [Track])
    func setDelegates()
    func setArtistImage(_ artistImage: String)
    func playSoundWithUrl(_ soundURL: String, andUpdateRow row: Int)
}

@objc protocol TopTracksViewDelegate: AnyObject {
    func topTracksViewDidTapOnCollectionViewCell(_ topTracksView: TopTracksView, soundURL: String, row: Int)
}

class TopTracksView: UIView {
    @IBOutlet private weak var topTracksCollectionView: UICollectionView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet private weak var delegate: TopTracksViewDelegate?
    
    var player: AVPlayer!
    
    var dataSource = [Track]() {
        didSet { self.topTracksCollectionView.reloadData() }
    }
}

extension TopTracksView: TopTracksViewProtocol {
    func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.topTracksCollectionView.layer.frame.width, height: 60)
        flowLayout.sectionInset = UIEdgeInsets(top: 60, left: 0, bottom: 60, right: 0)

        self.topTracksCollectionView.collectionViewLayout = flowLayout
    }
    
    func setDataSource(_ dataSource: [Track]) {
        self.dataSource = dataSource
    }
    
    func setDelegates() {
        self.topTracksCollectionView.dataSource = self
        self.topTracksCollectionView.delegate = self
    }
    
    func setArtistImage(_ artistImage: String) {
        if let url = URL(string: artistImage) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.artistImage.image = UIImage(data: imageData as Data)
                }
            }.resume()
        }
    }
    
    func playSoundWithUrl(_ soundURL: String, andUpdateRow row: Int) {
        guard  let url = URL(string: soundURL) else {
            print("error to get the mp3 file")
            
            return
        }
        
        player = AVPlayer(url: url as URL)
        guard let player = player else { return }
        self.updateCurrentPlayingForRow(row)
        
        player.play()
    }
    
    func updateCurrentPlayingForRow(_ row: Int) {
        let index = self.dataSource.firstIndex{$0.isPlatying == true}
        if (index != nil) {
            self.dataSource[index!].isPlatying = false
        }
        
        self.dataSource[row].isPlatying = true
        self.topTracksCollectionView.reloadData()
    }
}

extension TopTracksView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return TopTracksCollectionViewCell.buildIn(collectionView, in: indexPath, with: self.dataSource[indexPath.item])
    }
}

extension TopTracksView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.topTracksViewDidTapOnCollectionViewCell(self, soundURL: self.dataSource[indexPath.row].preview_url, row: indexPath.row)
    }
}
