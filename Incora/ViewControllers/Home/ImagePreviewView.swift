// Created by Tobiáš Hládek on 22/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import SwiftUI

struct ImagePreviewView: View {
    let store: Store<ImagePreviewDomain.State, ImagePreviewDomain.Action>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

            ZStack {
                Asset.Colors.secondaryColor.color.ignoresSafeArea()

                GeometryReader { proxy in
                    let screenWith = proxy.size.width
                    let screenHeight = proxy.size.height
                    HStack {
                        Spacer()
                            .frame(minWidth: 0)
                        VStack {
                            Spacer()
                                .frame(height: viewStore.fullscreen ? 0 : min(screenWith, screenHeight) * 0.1)
                            ZStack {
                                Group {
                                    Circle()
                                        .foregroundColor(Asset.Colors.primaryColor.color)
                                        .scaleEffect(1.2)
                                        .offset(y: 20)
                                    Circle()
                                        .foregroundColor(Asset.Colors.primaryColor.color.opacity(0.8))
                                        .scaleEffect(1.4)
                                        .offset(y: 45)
                                    Circle()

                                        .foregroundColor(Asset.Colors.primaryAccentColor.color)
                                        .frame(width: min(screenWith, screenHeight) * 0.82,
                                               height: min(screenWith, screenHeight) * 0.82)
                                    Circle()
                                        .foregroundColor(Asset.Colors.primaryColor.color)
                                        .frame(width: min(screenWith, screenHeight) * 0.8,
                                               height: min(screenWith, screenHeight) * 0.8)
                                }
                                if viewStore.isFetching { ProgressView() }
                                if viewStore.fetchFailed {
                                    Button(Strings.Common.retry) {
                                        viewStore.send(.downloadImage)
                                    }
                                    .padding(.horizontal)
                                    .foregroundColor(Asset.Colors.secondaryText.color)
                                    .background(Asset.Colors.secondaryAccentColor.color)
                                    .clipShape(Capsule())
                                }
                                if let image = viewStore.data {
                                    if viewStore.fullscreen {
                                        IncoraPDFView(image: image)
                                            .frame(width: screenWith,
                                                   height: screenHeight)
                                            .onTapGesture {
                                                viewStore.send(.changeImageSize, animation: .easeInOut)
                                            }
                                            .ignoresSafeArea()

                                    } else {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: min(screenWith, screenHeight) * 0.8,
                                                   height: min(screenWith, screenHeight) * 0.8)
                                            .cornerRadius(min(screenWith, screenHeight) * 0.4)
                                            .onTapGesture {
                                                viewStore.send(.changeImageSize, animation: .easeInOut)
                                            }
                                    }
                                }
                            }
                        }
                        Spacer()
                            .frame(minWidth: 0)
                    }
                }
                .ignoresSafeArea()
            }
            .onAppear {
                viewStore.send(.downloadImage)
            }
        }
    }
}

struct ImagePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreviewView(
            store: Store(
                initialState: .init(user: "ios-cz", password: "cleverlance"))
            {
                ImagePreviewDomain()
            }
        )
    }
}
