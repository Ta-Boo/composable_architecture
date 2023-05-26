// Created by Tobiáš Hládek on 25/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import XCTest

@MainActor
final class IncoraTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testLoginFail() async {
        let store = TestStore(initialState: LoginDomain.State(), reducer: LoginDomain(
            authorize: { _, _ in .unauthorized }
        ))
        await store.send(.loginTapped) {
            $0.username = ""
            $0.password = ""
            $0.dataFilled = false
            $0.isLoading = false
            $0.authorized = .requested
            $0.alert = nil
        }
        await store.receive(.login(.unauthorized), timeout: 2) {
            $0.username = ""
            $0.password = ""
            $0.dataFilled = false
            $0.isLoading = false
            $0.authorized = .unauthorized
            $0.alert = nil
        }
        await store.receive(.failAuthorization, timeout: 2) {
            $0.username = ""
            $0.password = ""
            $0.dataFilled = false
            $0.isLoading = false
            $0.authorized = .unauthorized
            $0.alert = AlertState(title: TextState(Strings.Login.AuthorizationFailed.title),
                                  message: TextState(Strings.Login.AuthorizationFailed.message))
        }
    }

    func testLoginSuccess() {}
}
