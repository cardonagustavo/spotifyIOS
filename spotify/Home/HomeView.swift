//
//  HomeView.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 16/02/24.
//

import UIKit

protocol HomeViewProtocol {
    func addCustomStylesForSearchTextField()
    func addCustomStylesForSearchWrapperStackView()
    func setArtisList()
    func setDataSource(_ dataSource: [Artist])
    func setFlowLayout()
    func getSearchValue() -> String
    func getArtistByRow(_ row: Int) -> Artist
}

@objc protocol HomeViewDelegate: AnyObject {
    func homeViewDidTapArtistViewCellWith(_ homeView: HomeView, artistID id: String, andRow row: Int)
}

class HomeView: UIView {
    @IBOutlet private weak var delegate: HomeViewDelegate?
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchWrapperStackView: UIStackView!
    @IBOutlet private weak var artistsCollectionView: UICollectionView!
    @IBAction private func tapToCloseKeyboard(_ gesture: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    var dataSource = [Artist]() {
        didSet {
            self.artistsCollectionView.reloadData()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if (self.searchTextField != nil) {
            self.searchTextField.delegate = self
        }
    }
}

extension HomeView: HomeViewProtocol {    
    func addCustomStylesForSearchTextField() {
        self.searchTextField.textColor = .black
        searchTextField.attributedPlaceholder = NSAttributedString(string:"What do you want listen to ? ", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func addCustomStylesForSearchWrapperStackView() {
        self.searchWrapperStackView.layer.cornerRadius = 10
    }
    
    func setArtisList() {
        self.artistsCollectionView.dataSource = self
        self.artistsCollectionView.delegate = self
    }
    
    func setDataSource(_ dataSource: [Artist]) {
        self.dataSource = dataSource
    }
    
    func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.artistsCollectionView.layer.frame.width, height: 30)

        self.artistsCollectionView.collectionViewLayout = flowLayout
    }
    
    func getSearchValue() -> String {
        return self.searchTextField.text ?? ""
    }
    
    func getArtistByRow(_ row: Int) -> Artist {
        return self.dataSource[row]
    }
}

extension HomeView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return HomeCollectionViewCell.buildIn(collectionView, in: indexPath, with: self.dataSource[indexPath.item])
    }
}

extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.homeViewDidTapArtistViewCellWith(self, artistID: self.dataSource[indexPath.row].id, andRow: indexPath.row)
    }
}

extension HomeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
