//
//  Artist.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/5/7.
//

import Foundation

struct Artist: Decodable {
    /// The artist's Deezer id
    let id: Int
    
    /// The artist's name
    let name: String
    
    /// The url of the artist on Deezer
    let link: String
    
    /// The share link of the artist on Deezer
    let share: String
    
    /// The url of the artist picture. Add 'size' parameter to the url to change size. Can be 'small', 'medium', 'big', 'xl'
    let picture: String
    
    /// The url of the artist picture in size small.
    let pictureSmall: String
    
    /// The url of the artist picture in size medium.
    let pictureMedium: String
    
    /// The url of the artist picture in size big.
    let pictureBig: String
    
    /// The url of the artist picture in size xl.
    let pictureXL: String
    
    /// The number of artist's albums
    let numberOfAlbums: Int
    
    /// The number of artist's fans
    let numberOfFans: Int
    
    /// true if the artist has a smartradio
    let hasSmartRadio: Bool
    
    /// API Link to the top of this artist
    let tracklist: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case link
        case share
        case picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXL = "picture_xl"
        case numberOfAlbums = "nb_album"
        case numberOfFans = "nb_fan"
        case hasSmartRadio = "radio"
        case tracklist
    }
}

extension Artist {
    static var mock: Self {
        .init(
            id: 4,
            name: "X JAPAN",
            link: "",
            share: "",
            picture: "",
            pictureSmall: "",
            pictureMedium: "",
            pictureBig: "",
            pictureXL: "",
            numberOfAlbums: 4,
            numberOfFans: 4444,
            hasSmartRadio: false,
            tracklist: ""
        )
    }
}
