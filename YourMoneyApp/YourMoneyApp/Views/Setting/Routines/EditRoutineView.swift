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
    @State var routine:Routine?
    @State var editTitle: String = ""
    @State var isEdit: Bool = false
    var body: some View {
        VStack {
            TextField("タイトルを入力", text: $editTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)
            Button(action:{
                if let routine = routine {
                    saveChanges(routine)
                } else {
                    addRoutine()
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
    
    func saveChanges(_ routine: Routine) {
        routine.name = editTitle
        
        let fetchDescriptor = FetchDescriptor<Routine>()
        // 更新処理
        do {
            let routines = try modelContext.fetch(fetchDescriptor)
            
            if let updateRoutine = routines.first(where: { $0.id == routine.id }) {
                
                updateRoutine.name = editTitle
            }
        } catch {
            print("❌ データの取得または更新に失敗: \(error.localizedDescription)")
        }
    }
    
    func addRoutine() {
        let newRoutine = Routine(name: editTitle, done: false, imageName: "bath")
        // 更新処理
        modelContext.insert(newRoutine)
        do {
            try modelContext.save()
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    EditRoutineView()
    .modelContainer(for: RoutineTitle.self)
}
