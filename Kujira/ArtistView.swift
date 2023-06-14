//
//  ArtistView.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/5/7.
//

import Foundation
import Combine
import SwiftUI

final class ArtistViewModel: ObservableObject {
    
    @Published var artist: Artist?
    
    private var getArtist: (Int) -> AnyPublisher<Artist, Error>
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        getArtist: @escaping (Int) -> AnyPublisher<Artist, Error>
    ) {
        self.getArtist = getArtist
    }
    
    func onAppear(id: Int) {
        self.getArtist(id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { self.artist = $0 }
            )
            .store(in: &cancellables)
    }
}

struct ArtistView: View {
    @ObservedObject var vm: ArtistViewModel
    
    var body: some View {
        VStack {
            if let name = vm.artist?.name {
                Text(name)
            } else {
                Text("🎼")
            }
        }
        .onAppear {
            vm.onAppear(id: 5919)
        }
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView(
            vm: .init(
                getArtist: { _ in
                    Just(Artist.mock)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            )
        )
    }
}
