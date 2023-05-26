// Created by Tobiáš Hládek on 24/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import CryptoKit
import Foundation

enum BootcampEndpoint {
    case image(username: String, password: String)
}

extension BootcampEndpoint: Endpoint {
    var path: String {
        switch self {
        case .image:
            return "/download/bootcamp/image.php"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .image:
            return .post
        }
    }

    var header: [String: String]? {
        switch self {
        case let .image(_, password):
            guard let data = password.data(using: .ascii) else { return [:] }
            return [
                "Authorization": Insecure.SHA1.hash(data: data).map { String(format: "%02X", $0).lowercased() }.joined(),
            ]
        }
    }

    var body: [String: String]? {
        switch self {
        case let .image(username, _):
            return ["username": username]
        }
    }
}

protocol BootcampServiceable {
    func getImage(username: String, password: String) async -> Result<ImageDTO, NetworkingError>
}

struct BootcampService: NetworkService, BootcampServiceable {
    func getImage(username: String, password: String) async -> Result<ImageDTO, NetworkingError> {
        return await sendRequest(endpoint: BootcampEndpoint.image(username: username, password: password))
    }
}
