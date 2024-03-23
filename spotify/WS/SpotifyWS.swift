//
//  SpotifyWS.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 16/02/24.
//

import Foundation
import Alamofire

// MARK: - WebServices
class SpotifyWS {
    let clientId = "25008cfe191843e79e450e566df8030d"
    let clientSecret = "045dcbf4be9747f194b5e877af688332"
    let urlString = "https://accounts.spotify.com/api/token?grant_type=client_credentials&client_id={clientId}&client_secret={clientSecret}"
    let urlSearchByArtist = "https://api.spotify.com/v1/search?q={query}&type=artist"
    let urlGetTopTracksByArtist = "https://api.spotify.com/v1/artists/{artistId}/top-tracks?market=es"

    func retrieveToken(completionHandler: @escaping CompletionTokenHandler)  {
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        let urlRequest = urlString.replacingOccurrences(of: "{clientId}", with: clientId).replacingOccurrences(of: "{clientSecret}", with: clientSecret)
        
        AF.request(urlRequest, method: .post, headers: headers).response { dataResponse in
            guard let data = dataResponse.data else { return }
            let response = try? JSONDecoder().decode(SpotifyTokentDTO.self, from: data)
            completionHandler(response ?? SpotifyTokentDTO())
        }
    }
    
    func searchByArtist(accessToken: String, query: String, completionHandler: @escaping CompletionSearchByArtistHandler)  {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        let urlRequest = urlSearchByArtist.replacingOccurrences(of: "{query}", with: query)

        AF.request(urlRequest, method: .get, headers: headers).response { dataResponse in
            guard let data = dataResponse.data else { return }
            let response = try? JSONDecoder().decode(ArtistResponseDTO.self, from: data)
            completionHandler(response ?? ArtistResponseDTO())
        }
    }
    
    func getTopTrackByArtist(accessToken: String, artistId: String, completionHandler: @escaping CompletionTopTracksByArtistHandler)  {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        let urlRequest = urlGetTopTracksByArtist.replacingOccurrences(of: "{artistId}", with: artistId)

        AF.request(urlRequest, method: .get, headers: headers).response { dataResponse in
            guard let data = dataResponse.data else { return print("error parsing data") }
            let response = try? JSONDecoder().decode(TracksResponseDTO.self, from: data)
            completionHandler(response ?? TracksResponseDTO())
        }
    }
}


// MARK: - Closures
extension SpotifyWS {
    typealias CompletionTokenHandler = (_ response: SpotifyTokentDTO) -> Void
    typealias CompletionSearchByArtistHandler = (_ response: ArtistResponseDTO) -> Void
    typealias CompletionTopTracksByArtistHandler = (_ response: TracksResponseDTO) -> Void
}

// MARK: - DTO
extension SpotifyWS {
    struct SpotifyTokentDTO: Decodable {
        let access_token: String?
        let token_type: String?
        let expires_in: Int?
        
        init() {
            self.access_token = ""
            self.token_type = ""
            self.expires_in = 0
        }
    }
    
    struct ArtistResponseDTO: Decodable {
        let artists: ArtistsDTO
        
        init() {
            self.artists = ArtistsDTO()
        }
    }
    
    struct ArtistsDTO: Decodable {
        let href: String?
        let limit: Int?
        let next: String?
        let offset: Int?
        let total: Int?
        let items: [ItemDTO]
        
        init() {
            self.href = ""
            self.limit = 0
            self.next = ""
            self.offset = 0
            self.total = 0
            self.items = [ItemDTO]()
        }
    }
    
    struct ItemDTO: Decodable {
        let genres: [String]?
        let href: String?
        let id: String?
        let name: String?
        let popularity: Int?
        let uri: String?
        let images: [ImageDTO]?
        
        init() {
            self.genres = [""]
            self.href = ""
            self.id = ""
            self.name = ""
            self.popularity = 0
            self.uri = ""
            self.images = [ImageDTO]()
        }
    }
    
    struct TracksResponseDTO: Decodable {
        let tracks: [TrackDTO]?
        
        init() {
            self.tracks = [TrackDTO]()
        }
    }
    
    struct TrackDTO: Decodable {
        let name: String?
        let album: AlbumDTO?
        let preview_url: String?
        
        init() {
            self.name = ""
            self.album = AlbumDTO()
            self.preview_url = ""
        }
    }
    
    struct AlbumDTO: Decodable {
        let images: [ImageDTO]?
        let artists: [TrackArtistDTO]?
        
        init() {
            self.images = [ImageDTO]()
            self.artists = [TrackArtistDTO]()
        }
    }
    
    struct TrackArtistDTO: Decodable {
        let name: String?
        
        init() {
            self.name = ""
        }
    }
    
    struct ImageDTO: Decodable {
        let url: String?
        
        init() {
            self.url = ""
        }
    }
}
