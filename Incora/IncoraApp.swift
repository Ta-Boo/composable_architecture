// Created by Tobiáš Hládek on 22/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import SwiftUI

@main
struct IncoraApp: App {
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(store: Store(
                initialState: .init())
            {
                MainCoordinator()
            })
        }
    }
}
