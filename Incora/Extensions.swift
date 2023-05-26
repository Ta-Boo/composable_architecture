// Created by Tobiáš Hládek on 22/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import Foundation
import SwiftUI

extension Optional where Wrapped == String {
    var orEmpty: String {
        guard let self = self else {
            return ""
        }
        return self
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    func convertBase64StringToImage() -> UIImage? {
        let imageData = Data(base64Encoded: self)
        let image = UIImage(data: imageData!)
        return image
    }
}

extension Image {
    init?(base64String: String?) {
        guard let base64String = base64String else { return nil }
        guard let data = Data(base64Encoded: base64String) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
    }
}

extension ViewStore {
    func send(_ action: Action, animation: Animation) {
        withAnimation(animation) {
            send(action)
        }
    }
}
