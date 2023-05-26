// Created by Tobiáš Hládek on 22/05/2023.
// Copyright © 2022 Zavarovalnica Triglav. All right reserved

import SwiftUI

struct ContentView: View {
    @State var presentSheet1: Bool = false
    @State var presentSheet2: Bool = false
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        ScrollView {
            VStack {
                Button {
                    presentSheet1 = true
                } label: {
                    Text("1 + \(presentSheet1 ? "true" : "false")")
                        .font(Font.system(size: 32))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.red)
                }

                Button {
                    presentSheet2 = true
                } label: {
                    Text("2 + \(presentSheet2 ? "true" : "false")")
                        .font(Font.system(size: 32))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.green)
                }
            }
        }
        .sheet(isPresented: $presentSheet1) {
            Color.red
        }
        .sheet(isPresented: $presentSheet2) {
            Color.green
        }.onChange(of: scenePhase) { newPhase in
            print(newPhase)
        }
    }
}
