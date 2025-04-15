//
//  SettingView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/21.
//

import SwiftUI

struct SettingView: View {
    var settingList: [String] = ["タイトル","したく","スタンプ"]
    var body: some View {
        NavigationStack {
            List {
                ForEach(settingList,id: \.self) { setting in
                    NavigationLink(destination: {
                        if setting == "タイトル" {
                            RoutineTitleListView()
                        }
                        if setting == "したく" {
                            RoutineListView()
                        }
                        if setting == "スタンプ" {
                            
                        }
                    }, label: {
                        Text(setting)
                    })
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
