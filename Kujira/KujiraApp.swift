//
//  KujiraApp.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/4/29.
//

import SwiftUI
import Combine
import ComposableArchitecture

@main
struct KujiraApp: App {
    var body: some Scene {
        WindowGroup {
            ArtistView(
                vm: .init(
                    getArtist: { id in
                        URLSession.shared
                            .dataTaskPublisher(for: URL(string: "https://api.deezer.com/artist/\(id)")!)
                            .tryMap(\.data)
                            .decode(type: Artist.self, decoder: JSONDecoder())
                            .eraseToAnyPublisher()
                    }
                )
            )
        }
    }
}
