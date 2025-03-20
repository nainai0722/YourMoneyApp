//
//  SwiftUIView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var moneys: [Money]
    @State private var selectedTab = 1  // 初期タブのインデックスを設定
    var body: some View {
        TabView {
            MoneyRecordView()
                .tabItem {
                    Label("おこづかい", systemImage: "nairasign.bank.building")
                }
                .tag(0)
            RoutineView(selectedTab: $selectedTab)
                .tabItem {
                    Label("おしたく", systemImage: "books.vertical")
                }
                .tag(1)
            RoutineCalendarView()
                .modelContainer(for: TodayData.self)
                .tabItem {
                    Label("カレンダー", systemImage: "calendar")
                }
                .tag(2)
            KindergartenCalendarView()
                .tabItem {
                    Label("ようちえん", systemImage: "figure.and.child.holdinghands")
                }
                .tag(3)
            
        }
    }
}

#Preview {
    MainTabView()
}

