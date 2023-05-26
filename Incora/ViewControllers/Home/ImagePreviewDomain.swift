// Created by Tobiáš Hládek on 24/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import Foundation
import SwiftUI

struct ImagePreviewDomain: ReducerProtocol {
    var fetchImage: (String, String) async -> Result<ImageDTO, NetworkingError> = { username, password in
        let result = await BootcampService().getImage(username: username, password: password)
        return result
    }

    struct State: Equatable {
        var user: String
        var password: String
        var data: UIImage?
        var fullscreen: Bool = false
        var isFetching = false
        var fetchFailed = true
    }

    enum Action: Equatable {
        case downloadImage
        case imageDownloadFailed(NetworkingError)
        case imageDownloadSuceed(ImageDTO)
        case changeImageSize
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        _ = _printChanges()
        switch action {
        case .downloadImage:
            state.fetchFailed = false
            state.isFetching = true
            return .run { [username = state.user, password = state.password] send in
                switch await fetchImage(username, password) {
                case let .success(data):
                    await send(.imageDownloadSuceed(data))
                case let .failure(error):
                    await send(.imageDownloadFailed(error))
                }
            }

        case .changeImageSize:
            state.fullscreen.toggle()
            return .none
        case let .imageDownloadFailed(error):
            state.isFetching = false
            switch error {
            // ....
            default:
                state.fetchFailed = true
            }
            return .none
        case let .imageDownloadSuceed(image):
            state.isFetching = false
            state.data = image.image.convertBase64StringToImage()
            return .none
        }
    }
}
