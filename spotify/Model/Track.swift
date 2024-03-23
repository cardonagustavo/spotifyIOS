//
//  Track.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 19/02/24.
//

import Foundation

struct Track {
    let name: String
    let albums: SpotifyWS.AlbumDTO
    let preview_url: String
    var isPlatying: Bool
    
    init(dto: SpotifyWS.TrackDTO) {
        self.name = dto.name ?? ""
        self.albums = dto.album ?? SpotifyWS.AlbumDTO()
        self.preview_url = dto.preview_url ?? ""
        self.isPlatying = false
    }
}

extension Array where Element == SpotifyWS.TrackDTO {
    var toList: [Track] {
        self.map( { Track(dto: $0) } )
    }
}

extension Array where Element == Track {
    var filterByPreviewURL: [Track] {
        self.filter { $0.preview_url != "" }
    }
}
