//
//  EditRoutineTitleView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/20.
//

import SwiftUI
import SwiftData

struct EditRoutineTitleView_old: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var routineTitle: RoutineTitle
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("\(routineTitle.name)")
        Text("\(routineTitle.done)")
        
        ForEach(routineTitle.routines, id: \.id) { routine in
            HStack {
                Text("\(routine.name)")
                Text("\(routine.done)")
            }
        }
        
    }
}

#Preview {
    EditRoutineTitleView_old(routineTitle: .constant(RoutineTitle(name: "test")))
        .modelContainer(for: RoutineTitle.self)
}


let calendar = Calendar(identifier: .gregorian)
let date20250301 = calendar.date(from: DateComponents(year: 2025, month: 3, day: 1))

struct DoneRoutineView_old: View {
    @Binding var selectedTab: Int  // MainTabView から渡す
    @Environment(\.modelContext) private var modelContext
    @Query private var todayDatas: [TodayData]
    @Query private var routineTitles: [RoutineTitle]
    @State var todayData:TodayData = TodayData()
    @State var routineName: String = ""
    @State var routines :[Routine] = []
    var body: some View {
        NavigationSplitView {
            ZStack {
                VStack {
                    Text(routineName)
                        .font(.title)
                    Menu("したくをえらぶ") {
                        ForEach(todayData.routineTitles,id:\.id) { routineTitle in
                            Button(routineTitle.name, action: {
                                routines = routineTitle.routines
                                routineName = routineTitle.name
                            })
                        }
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
            testData()
            fetchRoutineTitle()
            fetchTodayData()
        }
        
    }
    
    private func fetchRoutineTitle() {
        if routineTitles.isEmpty {
            addDefaultsRoutineTitle()
        }
    }

    private func addDefaultsRoutineTitle() {
        let newRoutineTitle1 = RoutineTitle(name: "あさのしたく", routines: Routine.mockMorningRoutines)
        let newRoutineTitle2 = RoutineTitle(name: "ゆうがたのしたく", routines: Routine.mockEveningRoutines)
        let newRoutineTitle3 = RoutineTitle(name: "ねるまえのしたく", routines: Routine.mockSleepTimeRoutines)
        do {
            try modelContext.insert(newRoutineTitle1)
            try modelContext.insert(newRoutineTitle2)
            try modelContext.insert(newRoutineTitle3)
            try modelContext.save()
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    
    func testData() {
        print("テストデータ")
        
        self.todayData = TodayData(timestamp: Date(), routineTitles: routineTitles)
        
        for title in self.todayData.routineTitles {
            print("\(title.name)")
            print("done: \(title.done)")
        }
        print("テストデータ終わり")
    }
    
    private func fetchTodayData() {
        let fetchDescriptor = FetchDescriptor<TodayData>()
        if let allDays = try? modelContext.fetch(fetchDescriptor) {
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                self.todayData = todayData
                print("今日のデータ: \(todayData.timestamp.formatted())")
                print("routineTitles一覧")
                for title in routineTitles {
                    print("\(title.name)")
                    print("done: \(title.done)")
                }
                if todayData.routineTitles.isEmpty {
                    print("代入")
                    todayData.routineTitles = routineTitles
                }
                print("今日のデータのroutineTitles一覧")
                for title in todayData.routineTitles {
                    print("\(title.name)")
                    print("done: \(title.done)")
                    for routine in title.routines {
                        print("\(routine.name)")
                        print("done: \(routine.done)")
                    }
                }
            } else {
                print("今日のデータがないので新規作成")
                
                self.todayData = TodayData(timestamp: Date(), routineTitles: routineTitles)
                
                for title in self.todayData.routineTitles {
                    print("\(title.name)")
                    print("done: \(title.done)")
                }
                try? modelContext.insert(self.todayData) // SwiftDataに保存
                
            }
        }
    }
    
    func updateRoutinesDone() {
        print("ルーティンの更新")
        
        let fetchDescriptor = FetchDescriptor<TodayData>()
        do {
            let allDays = try modelContext.fetch(fetchDescriptor)
            let today = Calendar.current.startOfDay(for: Date()) // 今日の0:00のタイムスタンプ
            
            if let todayData = allDays.first(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }) {
                for routine in todayData.routineTitles {
                    print("\(routine.name): \(routine.done)")
                }
                
                // すでに完了済みなら何もしない
                if let selectedRoutine = todayData.routineTitles.filter({ $0.name == routineName }).first, selectedRoutine.done == true {
                    return
                }
                
                // すべてのdoneがtrueなら morningRoutineDone を更新
                if routines.allSatisfy(\.done) {
                    
                    if let selectedRoutine = todayData.routineTitles.filter({ $0.name == routineName }).first, selectedRoutine.done == false {
                        selectedRoutine.done = true
                    }
                    
                    try modelContext.save()
                }
            }
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
    }
    
    func allDoneCheck() -> Bool {
        if routines.isEmpty { return false }
        return routines.allSatisfy(\.done)
    }
    
    func allReset() {
        for i in 0..<routines.count {
            routines[i].done = false
        }
    }
}

#Preview {
    DoneRoutineView_old(selectedTab: .constant(1))
        .modelContainer(for: [TodayData.self,RoutineTitle.self])
}
