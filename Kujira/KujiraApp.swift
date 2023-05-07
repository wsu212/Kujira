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
            DeezerView()
//            ContentView(viewModel: .init(
//                register: { _, _ in
//                    Just((Data("true".utf8), URLResponse()))
//                        .setFailureType(to: URLError.self)
//                        .eraseToAnyPublisher()
//                },
//                validatePassword: mockValidate(password:)
//            ))
        }
    }
}
