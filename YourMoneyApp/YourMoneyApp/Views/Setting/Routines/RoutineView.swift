//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI
import SwiftData

struct RoutineView: View {
    @State var routineTitle:RoutineTitle
    @Query private var routines: [Routine]
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(routines) { routine in
                        NavigationLink {
                            EditRoutineView(
                                routine: routine
                            )
                        } label: {
                            Text(routine.name)
                        }

                    }
                    
                    NavigationLink {
                        EditRoutineView(
                        )
                    } label: {
                        Text("新しいしたくを追加する")
                    }
                }
            }
        }
        .navigationTitle(Text(routineTitle.name))
    }
}

#Preview {
    RoutineListView()
        .modelContainer(for: RoutineTitle.self)
        .modelContainer(for: Routine.self)
}
