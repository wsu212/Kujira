//
//  RegistrationViewModelTests.swift
//  KujiraTests
//
//  Created by 蘇偉綸 on 2023/4/29.
//

import XCTest
import Combine
@testable import Kujira

final class RegistrationViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    
    func test_registerationSuccessful() {
        let vm = RegistrationViewModel(
            register: { _, _ in
                Just((Data("true".utf8), URLResponse()))
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
            }
        )
        
        var isRegistered: [Bool] = []
        
        vm.$isRegistered
            .sink {
                isRegistered.append($0)
            }
            .store(in: &cancellables)
        
        XCTAssertEqual(isRegistered, [false])
        
        // When:
        // 1. user enters email & password
        vm.email = "blob@kujira.co"
        XCTAssertEqual(isRegistered, [false])
        
        vm.password = "kujira is awesome"
        XCTAssertEqual(isRegistered, [false])
        
        // 2. user tapes registration button
        vm.registerButtonTapped()
        
        // Then
        XCTAssertEqual(isRegistered, [false, true])
    }
    
    func test_registerationFailure() {
        let vm = RegistrationViewModel(
            register: { _, _ in
                Just((Data("false".utf8), URLResponse()))
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
            }
        )
        
        XCTAssertFalse(vm.isRegistered)
        
        // When:
        // 1. user enters email & password
        vm.email = "blob@kujira.co"
        vm.password = "kujira is awesome"
        
        // 2. user tapes registration button
        vm.registerButtonTapped()
        
        // Then:
        // 1. user is not registered
        XCTAssertFalse(vm.isRegistered)
        // 2. A SwiftUI alert view is presented
        XCTAssertEqual(vm.errorAlert?.title, "Failed to register. Please try again.")
    }
}
