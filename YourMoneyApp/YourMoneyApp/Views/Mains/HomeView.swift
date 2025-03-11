//
//  HomeView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/10.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationSplitView {
            NavigationLink {
                MoneyRecordView()
            } label: {
                Text("おこづかい画面")
                    .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .green, fontType: .headline))
            }
            NavigationLink {
                RoutineView()
            } label: {
                Text("あさの支度")
                    .modifier(CustomButtonLayoutWithSetColor(textColor: .white, backGroundColor: .orange, fontType: .headline))
            }
        } detail: {
            Text("画面を選んでください")
        }
        
    }
}

#Preview {
    HomeView()
}
