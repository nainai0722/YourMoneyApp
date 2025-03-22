//
//  RoutineListView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/20.
//

import SwiftUI
import SwiftData

struct RoutineTitleListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var routineTitles: [RoutineTitle]
    @State var isPresented :Bool = false
    @State private var selectedRoutineTitle: RoutineTitle?
    var body: some View {
        VStack {
            List {
                ForEach(routineTitles, id: \.id) { routineTitle in
                    Button(action: {
                        selectedRoutineTitle = routineTitle  // クリックしたら選択する
                    }) {
                        Text("\(routineTitle.name)")
                    }
                }
                Button(action:{
                    print("押した")
                    isPresented.toggle()
                }){
                    Text("新しいしたくを追加する")
                }
            }
        }
        .navigationTitle(Text("おしたくリスト"))
        .overlay(
            AddRoutineTitleView(isPresented: $isPresented)
        )
        .sheet(item: $selectedRoutineTitle) { routineTitle in
            EditRoutineTitleView(routineTitle: Binding(
                    get: { routineTitle },
                    set: { selectedRoutineTitle = $0 }
                ))
        }
    }
    
    func deleteRoutineTitle(_ routineTitle: RoutineTitle) {
        do {
            try modelContext.delete(routineTitle)
        } catch {
            print("削除エラー: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RoutineTitleListView()
        .modelContainer(for: RoutineTitle.self)
}

struct AddRoutineTitleView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State var routineName: String = ""
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)  // 透明な黒背景
                .edgesIgnoringSafeArea(.all)  // 画面全体を覆う
                .opacity(isPresented ? 1 : 0)
            
            if isPresented {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(0.4)
                    .frame(width: 300, height: 200)
                VStack(alignment: .center) {
                    TextField("おしたくを追加する", text:$routineName)
                    Button(action:{
                        if !routineName.isEmpty {
                            addRoutineTitle(name: routineName)
                        }
                        isPresented = false
                        routineName = ""
                    }){
                        Text("閉じる")
                    }
                }
                .frame(width: 300, height: 200)
            }
            
        }
    }
    func addRoutineTitle(name: String) {
        let newRoutineTitle = RoutineTitle(name: name, routines: Routine.mockThreeRoutines)
        do {
            try modelContext.insert(newRoutineTitle)
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
}
