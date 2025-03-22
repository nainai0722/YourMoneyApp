//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI
import SwiftData

struct RoutineView: View {
    var routineTitle:RoutineTitle = RoutineTitle(name: "ゆうがたのしたく", routines: Routine.mockEveningRoutines)
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(routineTitle.routines,id:\.id) {routine in
                        NavigationLink {
                            Text(routine.name)
                        } label: {
                            Text(routine.name)
                        }
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
}
