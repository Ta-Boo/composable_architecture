// Created by Tobiáš Hládek on 24/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import SwiftUI

struct IncoraProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            ProgressView(Strings.Common.processing)
                .scaleEffect(1.2)
        }
    }
}
