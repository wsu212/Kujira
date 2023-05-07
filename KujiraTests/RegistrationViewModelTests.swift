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
    func test_registerationSuccessful() {
        let vm = RegistrationViewModel(
            register: { _, _ in
                Just((Data("true".utf8), URLResponse()))
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
        
        // Then
        XCTAssertTrue(vm.isRegistered)
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
