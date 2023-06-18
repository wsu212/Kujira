//
//  ArtistView.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/5/7.
//

import Foundation
import Combine
import SwiftUI

final class ViewModel: ObservableObject {
    
    @Published var games: [Game]?
    
    private var getGames: () -> AnyPublisher<[Game], Error>
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        getGames: @escaping () -> AnyPublisher<[Game], Error>
    ) {
        self.getGames = getGames
    }
    
    func fetchGames() {
        self.getGames()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { self.games = $0 }
            )
            .store(in: &cancellables)
    }
}

struct SwiftUIView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        List(self.vm.games ?? []) { game in
            VStack(alignment: .leading) {
                Text(game.title)
                Text(game.genre)
                Text(game.developer)
            }
        }
        .onAppear {
            vm.fetchGames()
        }
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(
            vm: .init(
                getGames: {
                    Just([Game.mock])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            )
        )
    }
}
