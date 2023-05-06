//
//  ContentView.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/4/29.
//

import SwiftUI
import Combine

final class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isRegistered = false
    
    var cancellables: Set<AnyCancellable> = []
    
    /// A closure that takes email & password as parameter, and returns a publisher
    let register: (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    
    init(
        register: @escaping (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    ) {
        self.register = register
    }
    
    func registerButtonTapped() {
        register(
            self.email,
            self.password
        )
        .map { data, _ in
            Bool(String(decoding: data, as: UTF8.self)) ?? false
        }
        .replaceError(with: false)
        .sink { self.isRegistered = $0 }
        .store(in: &cancellables)
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.isRegistered {
                Text("Welcome!")
            } else {
                Form {
                    Section(header: Text("Email")) {
                        TextField(
                            "blob@kujira.co",
                            text: $viewModel.email
                        )
                    }
                    Section(header: Text("Password")) {
                        TextField(
                            "Password",
                            text: $viewModel.password
                        )
                    }
                    Button("Register") { viewModel.registerButtonTapped() }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(
            register: { _, _ in
                Just((data: Data("true".utf8), URLResponse()))
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
            })
        )
    }
}
