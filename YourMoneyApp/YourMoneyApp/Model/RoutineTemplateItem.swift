//
//  RoutineTemplateItem.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import Foundation
import SwiftData

@Model
final class RoutineTemplateItem: Identifiable {
    var id : UUID?
    var name: String
    var done: Bool
    var imageName: String
    @Relationship(inverse: \RoutineTitle.routines)
        var title: RoutineTitle?
    
    init(id: UUID? = nil, name: String, done: Bool, imageName: String) {
        self.id = id
        self.name = name
        self.done = done
        self.imageName = imageName
    }
    
    static let mockWearRoutine = RoutineTemplateItem(id: UUID(), name: "きがえる", done: true, imageName: "wear")
    static let mockEatRoutine = RoutineTemplateItem(id: UUID(), name: "たべる", done: false, imageName: "eat")
    static let mockEToiletRoutine = RoutineTemplateItem(id: UUID(), name: "トイレ", done: false, imageName: "toilet")
    static let mockBottleRoutine = RoutineTemplateItem(id: UUID(), name: "水筒", done: false, imageName: "bottle")
    static let mockGoodsRoutine = RoutineTemplateItem(id: UUID(), name: "給食セット", done: false, imageName: "goods")
    static let scale = RoutineTemplateItem(id: UUID(), name: "けんおん", done: false, imageName: "scale")
    static let mock2 = RoutineTemplateItem(id: UUID(), name: "カレンダー", done: false, imageName: "calender")
    static let mock3 = RoutineTemplateItem(id: UUID(), name: "お風呂", done: false, imageName: "bath")
    static let mock4 = RoutineTemplateItem(id: UUID(), name: "お風呂", done: false, imageName: "bath")
    static let mock5 = RoutineTemplateItem(id: UUID(), name: "かみをかわかす", done: false, imageName: "dry")
    static let mock6 = RoutineTemplateItem(id: UUID(), name: "はみがきをする", done: false, imageName: "hamigaki")
    // タオル
    static let mock7 = RoutineTemplateItem(id: UUID(), name: "タオル", done: false, imageName: "towel_kake")
    // 箸
    static let mock8 = RoutineTemplateItem(id: UUID(), name: "おはし", done: false, imageName: "syokki_hashi_woman")
    // 給食セット
    static let mock9 = RoutineTemplateItem(id: UUID(), name: "給食セット", done: false, imageName: "kyusyoku_fukuro")
    
    static let mockThreeRoutines: [RoutineTemplateItem] = [mockEatRoutine, mockEToiletRoutine, mockWearRoutine]
    
    static let mockMorningRoutines: [RoutineTemplateItem] = [
        // きがえる・たべる・トイレ・水筒・給食セット・はみがきをする・タオル・おはし・ランチョンマット・上着
        .mockWearRoutine,
        .mockEatRoutine,
        .mockEToiletRoutine,
        .mockBottleRoutine,
        .mockGoodsRoutine,
        .mock6,
        .mock8,
        .mock9
        
    ]
    
    static let mockEveningRoutines: [RoutineTemplateItem] = [
        .mockWearRoutine,
        .mockEatRoutine,
        .mockEToiletRoutine,
        .mockBottleRoutine,
        .mockGoodsRoutine,
    ]
    
    static let mockSleepTimeRoutines: [RoutineTemplateItem] = [
        mockEToiletRoutine,
        mock3,
        mock2,
        mock5,
        mock6
    ]
}

//
//enum RoutineType: String, CaseIterable, Codable {
//    case morning = "あさのしたく"
//    case evening = "ゆうがたのしたく"
//    case sleepTime = "寝るまえのしたく"
//    
//}
