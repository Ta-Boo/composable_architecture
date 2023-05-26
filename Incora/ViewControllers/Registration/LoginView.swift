// Created by Tobiáš Hládek on 22/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    let store: Store<LoginDomain.State, LoginDomain.Action>

    @State private var showingLoginScreen = false

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                GeometryReader { proxy in
                    let screenWith = proxy.size.width
                    let screenHeight = proxy.size.height
                    ZStack {
                        Group {
                            Asset.Colors.secondaryColor.color
                                .ignoresSafeArea()

                            Circle()
                                .scale(2)
                                .foregroundColor(Asset.Colors.primaryColor.color.opacity(0.35))
                                .offset(x: 0, y: screenHeight * 0.5)
                            Circle()
                                .scale(1.7)
                                .foregroundColor(Asset.Colors.primaryColor.color.opacity(0.35))
                                .offset(x: 0, y: screenHeight * 0.5)
                            Circle()
                                .scale(1.35)
                                .foregroundColor(Asset.Colors.primaryColor.color)
                                .offset(x: 0, y: screenHeight * 0.5)
                        }

                        VStack {
                            HStack {
                                Text(Strings.Login.title)
                                    .font(.largeTitle)
                                    .foregroundColor(Asset.Colors.primaryText.color)
                                    .bold()
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, screenWith * 0.1)
                                Spacer()
                            }

                            TextField(Strings.Login.Placeholder.username,
                                      text: viewStore.binding(get: { $0.username },
                                                              send: LoginDomain.Action.usernameFilled))
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .foregroundColor(Asset.Colors.primaryText.color)
                                .padding()
                                .frame(width: screenWith * 0.8, height: 50)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)

                            SecureField(Strings.Login.Placeholder.password,
                                        text: viewStore.binding(
                                            get: { $0.password },
                                            send:
                                                withAnimation { LoginDomain.Action.passwordFilled }
                                        ))
                                        .padding()
                                        .foregroundColor(Asset.Colors.primaryText.color)
                                        .frame(width: screenWith * 0.8, height: 50)
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(10)
                            Spacer()

                            Button(Strings.Login.Button.login) {
                                UIApplication.shared.endEditing()
                                viewStore.send(.loginTapped)
                            }
                            .frame(width: screenWith * 0.8, height: 50)
                            .foregroundColor(Asset.Colors.primaryText.color)
                            .background(Asset.Colors.secondaryAccentColor.color)
                            .cornerRadius(10)
                            .disabled(!viewStore.dataFilled)
                            .opacity(viewStore.dataFilled ? 1 : 0.1)
                            .animation(.spring(), value: viewStore.dataFilled)
                            .padding(.vertical)
                        }
                        if viewStore.authorized == .requested {
                            ProgressView()
                                .progressViewStyle(IncoraProgressStyle())
                        }
                    }.navigationBarHidden(true)
                        .alert(self.store.scope(state: \.alert, action: { $0 }), dismiss: .didCancelAlert)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: Store(
                initialState: LoginDomain.State())
            {
                LoginDomain(authorize: { _, _ in
                    .unauthorized
                })
            }
        )
    }
}
