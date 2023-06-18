//
//  Game.swift
//
//
//  Created by 蘇偉綸 on 2023/6/18.
//

import Foundation

struct Game: Decodable, Identifiable {
    let id: Int
    let year: Int
    let title: String
    let genre: String
    let developer: String
}

extension Game {
    static var mock: Self {
        .init(
            id: 1234,
            year: 2008,
            title: "Metal Gear Solid 4: Guns of the Patriots",
            genre: "Stealth Game",
            developer: "Kojima Productions"
        )
    }
}
