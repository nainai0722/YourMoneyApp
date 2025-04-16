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
            UserInfo.self,
            TodayData.self,
            Routine.self,
            RoutineTitle.self,
            RoutineTemplateItem.self,
            RoutineTitleTemplate.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//　マイグレーションエラー対策
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)


        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    
    
    init (){
//        resetDatabase()
    }
    

    func resetDatabase() {
        let container = try? ModelContainer(for: Money.self)
        let storeURL = container?.configurations.first?.url

        if let storeURL {
            try? FileManager.default.removeItem(at: storeURL)
            print("💾 データベースを削除しました")
        }
    }


}


