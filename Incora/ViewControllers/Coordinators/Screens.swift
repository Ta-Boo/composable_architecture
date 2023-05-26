// Created by Tobiáš Hládek on 22/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct Screen: ReducerProtocol {
    enum State: Equatable {
        case login(LoginDomain.State)
        case imagePreview(ImagePreviewDomain.State)
    }

    enum Action {
        case login(LoginDomain.Action)
        case imagePreview(ImagePreviewDomain.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.login, action: /Action.login) {
            LoginDomain()
        }
        Scope(state: /State.imagePreview, action: /Action.imagePreview) {
            ImagePreviewDomain()
        }
    }
}
