//
//  VaporClient.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/5/7.
//

import Foundation
import Combine

final class VaporClient {
    
    private static let baseURL = "http://127.0.0.1:8080"
    
    func getGames() -> AnyPublisher<[Game], Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "\(Self.baseURL)/games")!)
            .tryMap(\.data)
            .decode(type: [Game].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
