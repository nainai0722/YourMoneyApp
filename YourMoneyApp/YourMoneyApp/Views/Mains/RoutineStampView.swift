//
//  RoutineStampView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import SwiftUI
import SwiftData

struct RoutineStampView: View {
    @State var routines: [Routine] = Routine.mockRoutines
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    BubbleView(text:"できたらスタンプを押してね！" )
                    
                    
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach($routines, id: \.self) { routine in
                                StampCellView(routine: routine)
                            }
                        }
                    }
                }
                .padding()
                if allDoneCheck() {
                    AllDone_StampView()
                }
            }
            if allDoneCheck() {
                Button(action:{
                    allReset()
                }){
                    Text("もう一回やる")
                        .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .red, fontType: .title))
                }
            }
        }
    }
    func allDoneCheck() -> Bool {
        routines.allSatisfy(\.done)
    }
    
    func allReset() {
        for i in 0..<routines.count {
            routines[i].done = false
        }
    }
    
}

#Preview {
    RoutineStampView()
}

struct Done_StampView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red.opacity(0.85))
                    .frame(width: 90, height: 90) // サイズを指定
                Text("OK")
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(-40))
                    .font(.system(size: 50))

            }
            
        }
    }
}

struct AllDone_StampView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.red.opacity(0.85))
                    .frame(width: 300, height: 300) // サイズを指定
                Text("OK")
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(-40))
                    .font(.system(size: 250))

            }
            
        }
    }
}

struct StampCellView: View {
    @Binding var routine: Routine
    var size = ( UIScreen.main.bounds.width / 3 ) - 50
    var body: some View {
        Button(action:{
            routine.done.toggle()
        }){
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
//                .frame(width: 100, height: 100)
                .shadow(radius: 10)
                .overlay(content: {
                    VStack {
                        Done_StampView()
                    }
                    .opacity(routine.done ? 1 : 0)
                })
            }
            .padding()
        }
    }
}
