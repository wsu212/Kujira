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

    private let deezerClient: DeezerClient = .init()

    var body: some Scene {
        WindowGroup {
            ArtistView(
                vm: .init(
                    getArtist: deezerClient.getArtist(id:)
                )
            )
        }
    }
}
