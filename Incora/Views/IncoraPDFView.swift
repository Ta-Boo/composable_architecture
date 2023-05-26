// Created by Tobiáš Hládek on 24/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import SwiftUI

import PDFKit
import SwiftUI

struct IncoraPDFView: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context _: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument()
        guard let page = PDFPage(image: image) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
        return view
    }

    func updateUIView(_: PDFView, context _: Context) {
        // empty
    }
}
