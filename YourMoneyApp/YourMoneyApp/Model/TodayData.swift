//
//  TodayData.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/12.
//

import Foundation
import SwiftData

@Model
final class TodayData {
    var kindergartenCalendarGone: Bool = false
    var morningRoutine: [Routine] = Routine.mockMorningRoutines
    var morningRoutineDone: Bool = false
    var eveningRoutine: [Routine] = Routine.mockEveningRoutines
    var eveningRoutineDone: Bool = false
    var sleepTimeRoutine: [Routine] = Routine.mockSleepTimeRoutines
    var sleepTimeRoutineDone: Bool = false
    var moodType: MoodType?
    var bookReadDone: Bool = false
    var bookCount: Int = 0
    var timestamp: Date = Date()
    
    init(kindergartenCalendarGone: Bool, morningRoutine: [Routine], eveningRoutine: [Routine], moodType: MoodType? = nil, bookReadDone: Bool, bookCount: Int, timestamp: Date) {
        self.kindergartenCalendarGone = kindergartenCalendarGone
        self.morningRoutine = morningRoutine
        self.eveningRoutine = eveningRoutine
        self.moodType = moodType
        self.bookReadDone = bookReadDone
        self.bookCount = bookCount
        self.timestamp = timestamp
    }
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
    
    init() {
        self.kindergartenCalendarGone = false
        self.morningRoutine = Routine.mockMorningRoutines
        self.eveningRoutine = Routine.mockEveningRoutines
        self.sleepTimeRoutine = Routine.mockSleepTimeRoutines
        self.moodType = nil
        self.bookReadDone = false
        self.bookCount = 0
        self.timestamp = Date()
    }
}

enum MoodType: String, Codable, CaseIterable {
    case happy
    case sad
    case neutral
}
