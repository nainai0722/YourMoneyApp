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
            RoutineTitleTemplate.self,
            ImageData.self
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
//            EditRoutineView()
//            PinnedImageDataList()
            RootView()
                .onAppear() {
                    requestNotificationPermission()
                    scheduleNotification(title: "おはよう！", body: "今日の予定を確認しよう☀️", hour: 23, minute: 10)
                    if let image = UIImage(named: "bath") {
                        print("画像変換できた？")
                        saveImageToAppGroup(image: image, fileName: "bath.png")
                    }
                    
                    
                    
                    if let data = UserDefaults(suiteName: "group.com.nanasashihara.yourroutineapp")?.data(forKey: "pinnedImageData") {
                        print("💾 pinnedImageDataあります！サイズ: \(data.count)")
                    } else {
                        print("❌ pinnedImageDataが見つからない")
                    }


                }
//            ImageList()
            
        }
        .modelContainer(sharedModelContainer)
    }
    init (){
//        resetDatabase()
    }
    
    let appGroupID = "group.com.nanasashihara.yourroutineapp"
    func saveImageToAppGroup(image: UIImage, fileName: String) -> Bool {
        guard let data = image.pngData() else { return false }
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else { return false }
        
        let defaults = UserDefaults(suiteName: appGroupID)
        let imageData = ImageData(fileName: "bath", category: .life, isPinned: false, timestamp: Date())
        if let encoded = try? JSONEncoder().encode(imageData) {
            defaults?.set(encoded, forKey: "pinnedImageData")
            print("📦 ImageData 保存成功")
        }

        
        let fileURL = containerURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("画像の保存に失敗: \(error)")
            return false
        }
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


