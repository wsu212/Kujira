//
//  DeezerView.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/5/7.
//

import Foundation
import Combine
import SwiftUI

final class DeezerClient {
    var cancellables: Set<AnyCancellable> = []
    
    func getArtist(id: Int) {
        let url = URL(string: "https://api.deezer.com/artist/\(id)")!
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap(\.data)
            .decode(type: Artist.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { print ("#### Received completion: \($0).") },
                receiveValue: { print("#### Received artist: \($0).")}
            )
            .store(in: &cancellables)
    }
}

struct DeezerView: View {
    var client: DeezerClient = .init()
    
    var body: some View {
        Text("DEEZER")
            .onAppear {
                client.getArtist(id: 5919)
            }
    }
}

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
    let picture_small: String
    
    /// The url of the artist picture in size medium.
    let picture_medium: String
    
    /// The url of the artist picture in size big.
    let picture_big: String
    
    /// The url of the artist picture in size xl.
    let picture_xl: String
    
    /// The number of artist's albums
    let nb_album: Int
    
    /// The number of artist's fans
    let nb_fan: Int
    
    /// true if the artist has a smartradio
    let radio: Bool
    
    /// API Link to the top of this artist
    let tracklist: String
}
