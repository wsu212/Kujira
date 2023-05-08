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
            },
            validatePassword: { _ in Empty(completeImmediately: true).eraseToAnyPublisher() }
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
        
        // 3. wait for a small amount of time before we assert
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
        
        // Then
        XCTAssertEqual(isRegistered, [false, true])
    }
    
    func test_registerationFailure() {
        let vm = RegistrationViewModel(
            register: { _, _ in
                Just((Data("false".utf8), URLResponse()))
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
            },
            validatePassword: { _ in Empty(completeImmediately: true).eraseToAnyPublisher() }
        )
        
        XCTAssertFalse(vm.isRegistered)
        
        // When:
        // 1. user enters email & password
        vm.email = "blob@kujira.co"
        vm.password = "kujira is awesome"
        
        // 2. user tapes registration button
        vm.registerButtonTapped()
        
        // 3. wait for a small amount of time before we assert
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
        
        // Then:
        // 1. user is not registered
        XCTAssertFalse(vm.isRegistered)
        // 2. A SwiftUI alert view is presented
        XCTAssertEqual(vm.errorAlert?.title, "Failed to register. Please try again.")
    }
    
    func test_validatePassword() {
        let vm = RegistrationViewModel(
            register: { _, _ in fatalError() },
            validatePassword: mockValidate(password:)
        )
        
        var passwordValidationMessage: [String] = []
        
        vm.$passwordValidationMessage
            .sink {
                passwordValidationMessage.append($0)
            }
            .store(in: &cancellables)
        
        XCTAssertEqual(passwordValidationMessage, [""])
        
        vm.password = "blob"
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.31)
        XCTAssertEqual(passwordValidationMessage, ["", "Password is too short 👎"])
        
        vm.password = "blob is awesome"
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.21)
        XCTAssertEqual(passwordValidationMessage, ["", "Password is too short 👎"])
        
        vm.password = "blob is really awesome !!!!"
        _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.31)
        XCTAssertEqual(passwordValidationMessage, ["", "Password is too short 👎", "Password is too long 👎"])
    }
}
