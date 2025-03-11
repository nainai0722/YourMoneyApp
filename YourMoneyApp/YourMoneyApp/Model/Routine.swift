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
    static let mockBottleRoutine = Routine(id: UUID(), name: "水筒", done: false, imageName: "bottle", type: .morning, createdAt: Date())
    static let mockGoodsRoutine = Routine(id: UUID(), name: "給食セット", done: false, imageName: "goods", type: .morning, createdAt: Date())
    
    static let mock2 = Routine(id: UUID(), name: "カレンダー", done: false, imageName: "calender", type: .evening, createdAt: Date())
    static let mock3 = Routine(id: UUID(), name: "お風呂", done: false, imageName: "bath", type: .evening, createdAt: Date())
    static let mock4 = Routine(id: UUID(), name: "お風呂", done: false, imageName: "bath", type: .evening, createdAt: Date())
    static let mock5 = Routine(id: UUID(), name: "かみをかわかす", done: false, imageName: "dry", type: .evening, createdAt: Date())
    
    static let mockRoutines: [Routine] = [
        .mockWearRoutine,
        .mockEatRoutine,
        .mockEToiletRoutine,
        .mockBottleRoutine,
        .mockGoodsRoutine
    ]
    
    static let mockRoutines2: [Routine] = [
        mock2,
        mock3,
        mock4,
        mock5
    ]
    
}


enum RoutineType: String, CaseIterable, Codable {
    case morning = "あさのしたく"
    case evening = "ゆうがたのしたく"
    case sleepTime = "寝るまえのしたく"
    
}
