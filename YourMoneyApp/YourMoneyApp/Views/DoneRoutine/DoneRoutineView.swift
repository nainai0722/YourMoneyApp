//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/11.
//

import SwiftUI
import SwiftData


struct DoneRoutineView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var routineTitles: [RoutineTitleTemplate]
    @Query private var todayDatas: [TodayData]
    @State var todayData:TodayData = TodayData()
    @State var routineName: String = ""
    @State var routines :[Routine] = []
    var body : some View {
        VStack {
//            Text("DoneRoutineView2")
//            List {
////                検証用
////                ForEach(routineTitles){ title in
////                    Text(title.name)
////                }
////                ForEach(todayDatas){ data in
////                    Text(data.timestamp.formattedMonthDayString_JP)
////                }
////                ForEach(todayData.routineTitles){ title in
////                    Text(title.name)
////                }
//            }
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
        }
        .onAppear {
            print("DoneRoutineView2.onAppear")
            fetchTodayData()
//            makeNewTodayData()
            print(todayData.routineTitles.count)
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
                    var todayRoutineTitle: [RoutineTitle] = getRoutineTitles(routineTitles)
                    
                    todayData.routineTitles = todayRoutineTitle
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
                makeNewTodayData()
            }
        }
    }
    
    func getRoutineTitles(_ routineTitles: [RoutineTitleTemplate]) -> [RoutineTitle] {
        var todayRoutineTitle: [RoutineTitle] = []
        if routineTitles.isEmpty {
            let morningRoutines = Routine.mockMorningRoutines.map { $0.cloned() }
            let title1 = RoutineTitle(name: "あさのしたく", routines: morningRoutines)

            let mockSleepTimeRoutines = Routine.mockSleepTimeRoutines.map { $0.cloned() }
            let title2 = RoutineTitle(name: "ねるまえのしたく", routines: mockSleepTimeRoutines)

            let mockEveningRoutines = Routine.mockEveningRoutines.map { $0.cloned() }
            let title3 = RoutineTitle(name: "ゆうがたのしたく", routines: mockEveningRoutines)

            
            todayRoutineTitle.append(contentsOf: [title1, title2, title3])
            print("なにもないので、デフォルトを追加")
            print(todayRoutineTitle.count)
            for title in todayRoutineTitle {
                print("\(title.name)")
            }
            print("追加終わり")
        } else {
            for title in routineTitles {
                todayRoutineTitle.append(convertTemplateToRoutine(title))
            }
        }
        return todayRoutineTitle
    }
    
    func makeNewTodayData() {
        self.todayData = TodayData(timestamp: Date(), routineTitles:getRoutineTitles(routineTitles))
        
        for title in self.todayData.routineTitles {
            print("\(title.name)")
            print("done: \(title.done)")
        }
        modelContext.insert(self.todayData) // SwiftDataに保存
        do {
            try modelContext.save()
        }
        catch {
            
        }
    }
    
    func convertTemplateToRoutine(_ template: RoutineTitleTemplate) -> RoutineTitle {
        let convertedRoutines = template.routines.map { item in
            Routine(name: item.name, done: false, imageName: item.imageName)
        }
        return RoutineTitle(name: template.name, routines: convertedRoutines)
    }
    
    func convertRoutineToTemplate(_ routineTitle: RoutineTitle) -> RoutineTitleTemplate {
        let convertedTemplateRoutines = routineTitle.routines.map { item in
            RoutineTemplateItem(name: item.name, done: item.done, imageName: item.imageName)
        }
        return RoutineTitleTemplate(name: routineTitle.name, routines: convertedTemplateRoutines)
    }
}

extension Routine {
    func cloned() -> Routine {
        Routine(name: self.name, done: self.done, imageName: self.imageName)
    }
}

extension RoutineTitle {
    func cloned() -> RoutineTitle {
        let newRoutines = self.routines.map { $0.cloned() }
        return RoutineTitle(name: self.name, routines: newRoutines)
    }
}


#Preview {
    DoneRoutineView()
        .modelContainer(for: [
            TodayData.self,
            RoutineTitle.self,
            RoutineTitleTemplate.self
            
        ])
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


