//
//  Artist.swift
//  spotify
//
//  Created by Gustavo Adolfo Cardona Quintero on 16/02/24.
//

import Foundation

struct Artist {
    let name: String
    let id: String
    let images: [SpotifyWS.ImageDTO]
    
    init(dto: SpotifyWS.ItemDTO) {
        self.name = dto.name ?? ""
        self.id = dto.id ?? ""
        self.images = dto.images ?? []
    }
}
