//
//  YourMoneyAppApp.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import SwiftUI
import SwiftData

@main
struct YourMoneyAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Money.self,
            UserInfo.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            ContentView()
//            MoneyRecordView()
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }

}
