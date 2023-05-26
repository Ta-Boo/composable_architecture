// Created by Tobiáš Hládek on 22/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MainCoordinator: ReducerProtocol {
    struct State: Equatable, IndexedRouterState {
        var routes: [Route<Screen.State>] = [.root(.login(.init()), embedInNavigationView: true)]
    }

    enum Action: IndexedRouterAction {
        case routeAction(Int, action: Screen.Action)
        case updateRoutes([Route<Screen.State>])
    }

    var body: some ReducerProtocol<State, Action> {
        return Reduce<State, Action> { state, action in
            switch action {
            case let .routeAction(_, .login(.login(.authorized(username, password)))):
                state.routes = [.root(.imagePreview(.init(user: username, password: password)), embedInNavigationView: true)]
            default:
                break
            }
            return .none
        }.forEachRoute {
            Screen()
        }._printChanges()
    }
}

struct MainCoordinatorView: View {
    let store: StoreOf<MainCoordinator>

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) {
                CaseLet(
                    state: /Screen.State.login,
                    action: Screen.Action.login,
                    then: LoginView.init
                )

                CaseLet(
                    state: /Screen.State.imagePreview,
                    action: Screen.Action.imagePreview,
                    then: ImagePreviewView.init
                )
            }
        }
    }
}
