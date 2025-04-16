//
//  EditRoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/22.
//

import SwiftUI
import SwiftData

struct EditRoutineView: View {
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @Environment(\.modelContext) private var modelContext
    @State var routine:RoutineTemplateItem?
    @State var editTitle: String = ""
    @State var isEdit: Bool = false
    var routineTitleId : UUID
    var body: some View {
        VStack {
            TextField("タイトルを入力", text: $editTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
            if isEdit {
                Button(action: {
                    if let routine = routine {
                        delete(routine)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("削除")
                }
            }
            Button(action:{
                if let routine = routine {
                    update(routine)
                } else {
                    add()
                }
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text(isEdit ?"更新" : "保存")
            }
        }
        .onAppear() {
            if let routine = routine {
                editTitle = routine.name
                isEdit = true
            }
        }
    }

    func delete(_ routine: RoutineTemplateItem) {
        routine.name = editTitle
        
        let fetchDescriptor = FetchDescriptor<RoutineTitleTemplate>()
        // 削除処理
        do {
            let routineTitles = try modelContext.fetch(fetchDescriptor)
            let routineTitle = routineTitles.first(where: { $0.id == routineTitleId })
            
            if let routineTitle = routineTitle {
                routineTitle.routines.removeAll(where: { $0.id == routine.id } )
            }
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
        
        
    }
    
    func update(_ routine: RoutineTemplateItem) {
        routine.name = editTitle
        
        let fetchDescriptor = FetchDescriptor<RoutineTitleTemplate>()
        // 更新処理
        do {
            let routineTitles = try modelContext.fetch(fetchDescriptor)
            let routineTitle = routineTitles.first(where: { $0.id == routineTitleId })
            
            if let routineTitle = routineTitle, let updateRoutine = routineTitle.routines.first(where: { $0.id == routine.id }) {
                updateRoutine.name = editTitle
            }
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
    }
    
    func add() {
        let fetchDescriptor = FetchDescriptor<RoutineTitleTemplate>()
        
        do {
            let routineTitles = try modelContext.fetch(fetchDescriptor)
            let routineTitle = routineTitles.first(where: { $0.id == routineTitleId })
            print("routineTitle: \(routineTitle?.name)")
            if let routineTitle = routineTitle {
                let newRoutine = RoutineTemplateItem(name: editTitle, done: false, imageName: "bath")
                routineTitle.routines.append(newRoutine)
                modelContext.insert(newRoutine)
                print("保存処理完了")
            }
            try modelContext.save()
        } catch {
            print("❌ データの追加に失敗: \(error.localizedDescription)")
        }
    }
}

#Preview {
    EditRoutineView(routineTitleId: UUID())
    .modelContainer(for: RoutineTitleTemplate.self)
}
