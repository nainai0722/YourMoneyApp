//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/11.
//

import SwiftUI
import SwiftData

struct RoutineView: View {
    @Binding var selectedTab: Int  // MainTabView から渡す
    @Environment(\.modelContext) private var modelContext
    @Query private var todayDatas: [TodayData]
    @State var todayData:TodayData = TodayData()
    @State var routineType:RoutineType = .morning
    @State var routines :[Routine] = Routine.mockMorningRoutines
    @State var isShowCalendar: Bool = false
    @State var selectedDate: Date = Date()
    var body: some View {
        NavigationSplitView {
            ZStack {
                VStack {
                    Text(routineType.rawValue)
                        .font(.title)
                    Menu("したくをえらぶ") {
                        Button(RoutineType.morning.rawValue, action: {
                            routines = todayData.morningRoutine
                            routineType = .morning
                        })
                        Button(RoutineType.evening.rawValue, action: {
                            routines = todayData.eveningRoutine
                            routineType = .evening
                        })
                        Button(RoutineType.sleepTime.rawValue, action: {
                            routines = todayData.sleepTimeRoutine
                            routineType = .sleepTime
                        })
                    }
                    .menuStyle(ButtonMenuStyle())
                    
                    BubbleView(text:"できたらスタンプを押してね！" )
                    
                    RoutineStampView(routines: $routines)
                    
                    Spacer()
                    
                    if allDoneCheck() {
                        NavigationLink {
                            RoutineCalendarView()
                        } label: {
                            Text("カレンダーを見る")
                                .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .red, fontType: .title))
                        }
                    }
                }
                if allDoneCheck() {
                    AllDone_StampView()
                        .onAppear(){
                            updateRoutinesDone()
                        }
                }
            }
        } detail: {
            Text("Select an money")
        }
        .onAppear(){
            fetchTodayData()
        }
        
    }
    
    private func fetchTodayData() {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        if let allDays = try? modelContext.fetch(fetchDescriptor) {
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                self.todayData = todayData
                print("今日のデータ: \(todayData.timestamp.formatted())")
                print("朝の支度: \(todayData.morningRoutineDone)")
                print("夕方の支度: \(todayData.eveningRoutineDone)")
                print("寝る前の支度: \(todayData.sleepTimeRoutineDone)")
            } else {
                print("今日のデータがないので新規作成")
                self.todayData = TodayData()
                try? modelContext.insert(self.todayData) // SwiftDataに保存
            }
        }
    }
    
    private func deleteMarch12Data() {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            
            // 3/12 のデータをフィルタ
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            
            let targetDateString = "2025/03/12" // 削除対象の日付
            guard let targetDate = formatter.date(from: targetDateString) else { return }
            
            let march12Data = allDays.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: targetDate) }
            
            // 削除処理
            for data in march12Data {
                modelContext.delete(data)
            }
            
            try modelContext.save() // 削除を保存
            
            print("✅ 3/12 のデータを削除しました")
        } catch {
            print("❌ 削除に失敗: \(error.localizedDescription)")
        }
    }

    func updateRoutinesDone() {
        print("ルーティンの更新")
        
        let fetchDescriptor = FetchDescriptor<TodayData>()
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                print("あさのルーティンの完了状況:\(todayData.morningRoutineDone)")
                for routine in todayData.morningRoutine {
                    print("\(routine.name): \(routine.done)")
                }
                
                // すでに完了済みなら何もしない
                if routineType == .morning && todayData.morningRoutineDone { return }
                
                if routineType == .evening && todayData.eveningRoutineDone { return }
                
                if routineType == .sleepTime && todayData.sleepTimeRoutineDone { return }
                
                // すべてのdoneがtrueなら morningRoutineDone を更新
                if routines.allSatisfy(\.done) {
                    
                    switch routineType {
                    case .morning:
                        todayData.morningRoutineDone = true
                        for routine in todayData.morningRoutine {
                            routine.done = true
                        }

                    case .evening:
                        todayData.eveningRoutineDone = true
                        
                        for routine in todayData.eveningRoutine {
                            routine.done = true
                        }
                    case .sleepTime:
                        todayData.sleepTimeRoutineDone = true
                        for routine in todayData.sleepTimeRoutine {
                            routine.done = true
                        }
                    }
                    
                    try modelContext.save()
                    print("✅ \(routineType) を true に更新")
                }
            }
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
    }
    
    func allDoneCheck() -> Bool {
        return routines.allSatisfy(\.done)
    }
    
    func allReset() {
        for i in 0..<routines.count {
            routines[i].done = false
        }
    }
}

#Preview {
    RoutineView(selectedTab: .constant(1))
        .modelContainer(for: TodayData.self)
}

struct AllDone_StampView: View {
    @State private var offsetY: CGFloat = 500 // 画面下に隠しておく
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red.opacity(0.85))
                    .frame(width: 300, height: 300) // サイズを指定
                Text("OK")
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(-40))
                    .font(.system(size: 250))

            }
            .offset(y: offsetY) // 初期位置
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) {
                                offsetY = 0 // アニメーションで上に移動
                            }
                        }
        }
    }
}
