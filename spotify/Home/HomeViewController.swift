//
//  HomeViewController.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 16/02/24.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var webService = SpotifyWS()
    var homeView: HomeViewProtocol? {
        self.view as? HomeViewProtocol
    }
    var artistSelected: Artist?
    lazy var keyboardManager = KeyboardManager(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeView?.addCustomStylesForSearchTextField()
        self.homeView?.addCustomStylesForSearchWrapperStackView()
        self.homeView?.setArtisList()
        self.homeView?.setFlowLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.keyboardManager.registerKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.keyboardManager.unregisterKeyboardNotification()
    }
    
    private func getArtistsData() {
        self.webService.retrieveToken() { response in
            self.webService.searchByArtist(accessToken: response.access_token ?? "", query: self.homeView?.getSearchValue() ?? "") { searchResponse in
                var artistList = [Artist]()
                
                for artist in searchResponse.artists.items {
                    artistList.append(Artist(dto: artist))
                }
                
                self.homeView?.setDataSource(artistList)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TopTracksViewController" {
            guard let destinationViewController = segue.destination as? TopTracksViewController else { return }
            guard let artistID = sender as? String else { return }
            guard let artist = self.artistSelected else { return }
            
            destinationViewController.artist = artist
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    func homeViewDidTapArtistViewCellWith(_ homeView: HomeView, artistID id: String, andRow row: Int) {
        self.artistSelected = self.homeView?.getArtistByRow(row)
        self.performSegue(withIdentifier: "TopTracksViewController", sender: id)
    }
}

extension HomeViewController: KeyboardManagerDelegate {
    func keyboardManager(_ keyboardManager: KeyboardManager, keyboardWillShowWith info: KeyboardManager.Information) {
        print("Teclado aparece")
        print(info)
    }
    
    func keyboardManager(_ keyboardManager: KeyboardManager, keyboardWillHideWith info: KeyboardManager.Information) {
        print("Teclado desaparece")
        self.getArtistsData()
        print(info)
    }
}
