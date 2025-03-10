//
//  Routine.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import Foundation
import SwiftData

@Model
final class Routine {
    var id : UUID?
    var name: String
    var done: Bool
    var imageName: String
    var type: RoutineType
    var createdAt: Date
    
    init(id: UUID? = nil, name: String, done: Bool, imageName: String, type: RoutineType, createdAt: Date) {
        self.id = id
        self.name = name
        self.done = done
        self.imageName = imageName
        self.type = type
        self.createdAt = createdAt
    }
    
    static let mockWearRoutine = Routine(id: UUID(), name: "きがえる", done: false, imageName: "wear", type: .morning, createdAt: Date())
    static let mockEatRoutine = Routine(id: UUID(), name: "たべる", done: false, imageName: "eat", type: .morning, createdAt: Date())
    static let mockEToiletRoutine = Routine(id: UUID(), name: "トイレ", done: false, imageName: "toilet", type: .morning, createdAt: Date())
    
    static let mockRoutines: [Routine] = [
        .mockWearRoutine,
        .mockEatRoutine,
        .mockEToiletRoutine
        ]
    
}


enum RoutineType: String, CaseIterable, Codable {
    case morning
    case evening
    case sleepTime
    
}
