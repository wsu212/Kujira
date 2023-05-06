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
    
    let register: (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    
    init(register: @escaping (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>) {
        self.register = register
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Email")) {
                    TextField(
                        "blob@kujira.co",
                        text: .constant("")
                    )
                }
                Section(header: Text("Password")) {
                    TextField(
                        "Password",
                        text: .constant("")
                    )
                }
                
                Button("Register") {  }
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
