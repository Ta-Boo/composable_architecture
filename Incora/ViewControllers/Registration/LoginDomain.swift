// Created by Tobiáš Hládek on 22/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import Foundation
import SwiftUI

enum AuthorizationStatus: Equatable {
    case unauthorized, requested, authorized(String, String)
}

struct LoginDomain: ReducerProtocol {
    var authorize: (String, String) async throws -> AuthorizationStatus = { username, password in // async len pre buducnost (tato verifikacia by mala prejst na server)
        try await Task.sleep(nanoseconds: 2_000_000_000)
        if username == "ios-cz" && password == "cleverlance" {
            return .authorized(username, password)
        } else {
            return .unauthorized
        }
    }

    struct State: Equatable {
        var username: String = ""
        var password: String = ""
        var dataFilled: Bool = false
        var isLoading: Bool = false
        var authorized: AuthorizationStatus = .unauthorized
        var alert: AlertState<Action>?
    }

    enum Action: Equatable {
        case loginTapped
        case usernameFilled(String)
        case passwordFilled(String)
        case verify
        case login(AuthorizationStatus)
        case failAuthorization
        case didCancelAlert
    }

    struct Environment {
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .passwordFilled(password):
            state.password = password
            return EffectTask(value: .verify)

        case let .usernameFilled(username):
            state.username = username
            state.dataFilled = !state.password.isEmpty && !state.username.isEmpty
            return EffectTask(value: .verify)

        case .verify:
            let isFilled = !state.password.isEmpty && !state.username.isEmpty
            guard state.dataFilled != isFilled else { return .none }
            state.dataFilled = isFilled
            return EffectTask.none

        case .loginTapped:
            state.authorized = .requested
            return .run { [username = state.username, password = state.password] send in
                let status = try await authorize(username, password)
                await send(.login(status))
            }

        case let .login(authorizationState):
            state.authorized = authorizationState
            if authorizationState == .unauthorized {
                return EffectTask(value: .failAuthorization)
            }
            return .none

        case .failAuthorization:
            state.alert = AlertState(title: TextState(Strings.Login.AuthorizationFailed.title),
                                     message: TextState(Strings.Login.AuthorizationFailed.message))
            return .none

        case .didCancelAlert:
            state.alert = nil
            return .none
        }
    }
}
