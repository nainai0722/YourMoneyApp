//
//  RoutineCalendarView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/12.
//

import SwiftUI
import SwiftData

#Preview {
    
    RoutineCalendarView()
        .modelContainer(for: TodayData.self)
    
}

struct RoutineCalendarView:View {
    @Query private var todayDatas: [TodayData]
    @State var selectedTodayData: TodayData?
    @State private var showDetail = false
    
    var completeTodayDatas: [TodayData] {
        fillMissingDates(todayDatas: todayDatas)
    }
    var body: some View {
        VStack {
            Text("一週間のおしたく表")
                .font(.title)
                .bold()
                .padding()
            WeeklyTableView(selectedTodayData: $selectedTodayData)
            
            ScrollView(Axis.Set.horizontal) {
                HStack {
                    ForEach(completeTodayDatas, id: \.self) { todayData in
                        TodayDataCellView(todayData: todayData)
                    }
                }
            }
            
            
            if let selectedTodayData = selectedTodayData {
                TodayDataDetailView(selectedTodayData: selectedTodayData)
                    .padding(.top, 30)
                    
            }
            
        }
    }
    
    func dayCount() -> Int {
        todayDatas.count
    }
    
    func firstDay(_ index: Int) -> TodayData? {
        todayDatas.first
    }
    
    func lastDay(_ index: Int) -> TodayData? {
        todayDatas.last
    }
    
    func fillMissingDates(todayDatas: [TodayData]) -> [TodayData] {
        guard let first = todayDatas.first, let last = todayDatas.last else { return [] }
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: first.timestamp)
        let endDate = calendar.startOfDay(for: last.timestamp)
        
        var filledData: [TodayData] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            if let existingData = todayDatas.first(where: { calendar.isDate($0.timestamp, inSameDayAs: currentDate) }) {
                // 既存データがある場合はそのまま使う
                filledData.append(existingData)
            } else {
                // ない場合は新規作成
                let newData = TodayData(timestamp: currentDate)
                filledData.append(newData)
            }
            
            // 次の日に進める
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return filledData
    }
}

struct TodayDataCellView:View {
    var todayData:TodayData = TodayData()
    var size:CGFloat = 150
    var body: some View {
        VStack{
            Text(todayData.timestamp.formattedMonthDayString + todayData.timestamp.weekString)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
            if todayData.morningRoutineDone {
                DoneTypeWeeklyStampView()
            } else {
                EmptyCellView()
            }
            if todayData.eveningRoutineDone {
                DoneTypeWeeklyStampView()
            } else {
                EmptyCellView()
            }
            
        }
        .frame(width: size, height: size)
    }
    
    func week() -> String {
        todayData.timestamp.weekString
    }
}



struct WeeklyTableView: View {
    @Query private var todayDatas: [TodayData]
    @Binding var selectedTodayData: TodayData?
    let days = ["月", "火", "水", "木", "金", "土", "日"]

    var body: some View {
        VStack(spacing: 2) {
            // 曜日（ヘッダー）
            HStack(spacing: 2) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                }
            }

            // データ行
            HStack(spacing: 2) {
                
                WeekRoutineView(todayDatas: todayDatas, routineType: .morning, selectedTodayData: $selectedTodayData)
            }
            
            HStack(spacing: 2) {
                
                WeekRoutineView(todayDatas: todayDatas, routineType: .evening, selectedTodayData: $selectedTodayData)
            }
        }
    }
}

struct WeekRoutineView: View {
    let todayDatas: [TodayData] // 保持しているデータ
    let routineType:RoutineType
    @Binding var selectedTodayData: TodayData?

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<7, id: \.self) { index in
                if let matchingData = todayDatas.first(where: { data in
                    weekdayIndex(for: data.timestamp) == index + 1
                }) {
                    if isDone(todayData: matchingData, routineType: routineType) {
                        Button(action: {
                            print("\(matchingData.timestamp)が押された")
                            selectedTodayData = matchingData
                        }){
                            DoneTypeWeeklyStampView()
                        }
                    } else {
                        Button(action:{
                            selectedTodayData = nil
                        }){
                            EmptyCellView()
                        }
                    }
                } else {
                    Button(action:{
                        selectedTodayData = nil
                    }){
                        EmptyCellView()
                    }
                }
            }
        }
    }
    
    func isDone(todayData: TodayData, routineType:RoutineType) -> Bool {
        switch routineType {
        case .morning:
            return todayData.morningRoutineDone
        case .evening:
            return todayData.eveningRoutineDone
        case .sleepTime:
            return todayData.sleepTimeRoutineDone
        }
        
    }

    /// **日曜始まりの weekday を 月曜始まりに変換**
    func weekdayIndex(for date: Date) -> Int {
        let weekday = Calendar.current.component(.weekday, from: date)
        return (weekday == 1) ? 7 : (weekday - 1) // 1(日) → 7, 2(月) → 1, ..., 7(土) → 6
    }
}

struct DoneTypeWeeklyStampView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.red.opacity(0.85))
                .frame(width: 40, height: 40) // サイズを指定
            Text("OK")
                .foregroundStyle(.white)
                .rotationEffect(.degrees(-45))
                .font(.system(size: 15))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
        }
    }
}

struct EmptyCellView: View {
    var body: some View {
        Text("           ")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
    }
}

