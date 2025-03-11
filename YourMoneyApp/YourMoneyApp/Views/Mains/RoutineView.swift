//
//  RoutineView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/11.
//

import SwiftUI

struct RoutineView: View {
    @State var routines :[Routine] = Routine.mockRoutines
    @State var isShowCalendar: Bool = false
    @State var selectedDate: Date = Date()
    var body: some View {
        
        ZStack {
            VStack {
                Text(Title())
                    .font(.title)
                Menu("したくをえらぶ") {
                    Button(Title(routine: Routine.mockRoutines), action: { routines = Routine.mockRoutines })
                    Button(Title(routine: Routine.mockRoutines2), action: {
                        routines = Routine.mockRoutines2
                    })
                }
                .menuStyle(ButtonMenuStyle())
                
                BubbleView(text:"できたらスタンプを押してね！" )
                
                RoutineStampView(routines: $routines)
                
                Spacer()
                
                if allDoneCheck() {
                    Button(action:{
                        allReset()
                    }){
                        Text("もう一回やる")
                            .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .red, fontType: .title))
                    }
                    .transition(.opacity)
                    .animation(.default, value: allDoneCheck())
                }
            }
            if allDoneCheck() {
                AllDone_StampView()
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
    
    
    func Title() -> String {
        if let title = routines.first?.type.rawValue {
            return title
        }
        return "ルーティン"
    }
    
    func Title(routine:[Routine]) -> String {
        if let title = routine.first?.type.rawValue {
            return title
        }
        return "ルーティン"
    }
}

#Preview {
    RoutineView()
}

struct AllDone_StampView: View {
    @State private var offsetY: CGFloat = 500 // 画面下に隠しておく
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
            .offset(y: offsetY) // 初期位置
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) {
                                offsetY = 0 // アニメーションで上に移動
                            }
                        }
        }
    }
}
