//
//  TodayDataDetailView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/15.
//

import SwiftUI

struct TodayDataDetailView: View {
    var selectedTodayData: TodayData = TodayData()
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        VStack {
            Text("今日の詳細")
            Text(selectedTodayData.timestamp.formattedString)
            selectedTodayData.eveningRoutineDone ? Text("Evening routine is done") : Text("Evening routine is not done")
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(selectedTodayData.morningRoutine, id: \.self) { routine in
                        StampMiniCellView(routine: routine)
                    }
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(selectedTodayData.eveningRoutine, id: \.self) { routine in
                        StampMiniCellView(routine: routine)
                    }
                }
            }
            
            
            HStack {
                ForEach(1...5, id: \.self) { count in
                    if count <= selectedTodayData.bookCount {
                        Image(systemName: "book.fill")
                    } else {
                        Image(systemName: "book")
                    }
                }
            }
            switch selectedTodayData.moodType {
            case .happy:
                Image(systemName: "face.smiling")
            case .sad:
                Text("Sad")
            case .neutral:
                Text("Neutral")
            case .none:
                Image(systemName: "face.dashed")
            }
            
        }
        .padding() // 余白をつける
        .background(Color.white) // 背景を白に
        .cornerRadius(12) // 角丸にする
        .shadow(radius: 5) // 影をつける
        .padding(.horizontal) // 画面端にくっつかないようにする
    }
}

struct StampMiniCellView: View {
    var routine: Routine
    var size: CGFloat = 30
    var stampViews :[AnyView] = [AnyView(DoneTypeAStampView(size: 20)),AnyView(DoneTypeBStampView(size: 20))]
    @State private var selectedStamp: AnyView?
    var body: some View {
        ZStack {
            VStack {
                Image(routine.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:size , height:size )
                    .padding()
            }
            .background()
            .cornerRadius(8)
            .shadow(radius: 10)
            .overlay(content: {
                VStack {
                    selectedStamp
                }
                .opacity(routine.done ? 1 : 0)
            })
        }
        .onAppear(){
            print("\(routine.done)")
            if routine.done {
                selectedStamp = stampViews.randomElement() // スタンプをランダムで選択
            }
        }
        .padding()
    }
}

#Preview {
    TodayDataDetailView()
}
