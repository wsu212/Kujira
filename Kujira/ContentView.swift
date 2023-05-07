//
//  ContentView.swift
//  Kujira
//
//  Created by 蘇偉綸 on 2023/4/29.
//

import SwiftUI
import Combine

final class RegistrationViewModel: ObservableObject {
    struct Alert: Identifiable {
        var title: String
        var id: String { self.title }
    }
    @Published var email = ""
    @Published var password = ""
    @Published var isRegistered = false
    @Published var isRegisterRequestInFlight = false
    @Published var errorAlert: Alert?
    
    var cancellables: Set<AnyCancellable> = []
    
    /// A closure that takes email & password as parameter, and returns a publisher
    let register: (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    
    init(
        register: @escaping (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    ) {
        self.register = register
    }
    
    func registerButtonTapped() {
        self.isRegisterRequestInFlight = true
        register(
            self.email,
            self.password
        )
        .receive(on: DispatchQueue.main)
        .map { data, _ in
            Bool(String(decoding: data, as: UTF8.self)) ?? false
        }
        .replaceError(with: false)
        .sink {
            self.isRegistered = $0
            self.isRegisterRequestInFlight = false
            if !$0 {
                self.errorAlert = .init(title: "Failed to register. Please try again.")
            }
        }
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
                    if viewModel.isRegisterRequestInFlight {
                        Text("Registering...")
                    } else {
                        Button("Register") { viewModel.registerButtonTapped() }
                    }
                }
            }
        }
        .alert(item: self.$viewModel.errorAlert) { errorAlert in
            Alert(title: Text(errorAlert.title))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(
            register: { _, _ in
                Just((data: Data("false".utf8), URLResponse()))
                    .setFailureType(to: URLError.self)
                    .delay(for: 1, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            })
        )
    }
}
