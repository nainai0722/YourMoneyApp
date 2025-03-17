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
    var body: some View {
        TabView {
            MoneyRecordView()
                .tabItem {
                    Label("おこづかい", systemImage: "nairasign.bank.building")
                }
            RoutineView()
                .tabItem {
                    Label("おしたく", systemImage: "books.vertical")
                }
            RoutineCalendarView()
                .tabItem {
                    Label("カレンダー", systemImage: "calendar")
                }
            KindergartenCalendarView()
                .tabItem {
                    Label("ようちえん", systemImage: "figure.and.child.holdinghands")
                }
            
        }
    }
}

#Preview {
    MainTabView()
}

