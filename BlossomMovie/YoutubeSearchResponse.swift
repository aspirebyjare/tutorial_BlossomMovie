//
//  YoutubeSearchResponse.swift
//  BlossomMovie
//
//  Created by Jared Smith on 3/22/26.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [ItemProperties]?
}
struct ItemProperties: Codable {
    let id: IdProperties?
}
struct IdProperties: Codable {
    let videoId: String?
    
}
