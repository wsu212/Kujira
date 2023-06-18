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

    private let vaporClient: VaporClient = .init()

    var body: some Scene {
        WindowGroup {
            SwiftUIView(
                vm: .init(
                    getGames: vaporClient.getGames
                )
            )
        }
    }
}
