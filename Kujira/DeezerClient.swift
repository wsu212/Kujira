//
//  DeezerClient.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/5/7.
//

import Foundation
import Combine

final class DeezerClient {
    
    private static let baseURL = "https://api.deezer.com"
    
    func getArtist(id: Int) -> AnyPublisher<Artist, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "\(Self.baseURL)/artist/\(id)")!)
            .tryMap(\.data)
            .decode(type: Artist.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
