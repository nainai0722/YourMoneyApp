//
//  RoutineTitleTemplate.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/20.
//

import Foundation
import SwiftData

@Model
final class RoutineTitleTemplate: Identifiable {
    var id: UUID
    var name: String
    @Relationship var routines: [RoutineTemplateItem] = []
    var done: Bool
    
    init(id: UUID, name: String, routines: [RoutineTemplateItem], done: Bool) {
        self.id = id
        self.name = name
        self.routines = routines
        self.done = done
    }
    
    init(name: String) {
        self.name = name
        self.id = UUID()
        self.done = false
        self.routines = RoutineTemplateItem.mockThreeRoutines
    }
    init(name: String, routines: [RoutineTemplateItem]) {
        self.name = name
        self.id = UUID()
        self.done = false
        self.routines = routines
    }
}


