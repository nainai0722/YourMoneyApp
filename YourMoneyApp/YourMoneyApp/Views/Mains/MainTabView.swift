//
//  SwiftUIView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MoneySummaryView()
                .tabItem {
                    Label("Received", systemImage: "tray.and.arrow.down.fill")
                }

            ContentView()
                .tabItem {
                    Label("Sent", systemImage: "tray.and.arrow.up.fill")
                }

            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}


#Preview {
    MainTabView()
}
