//
//  MoneyListComponent.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI
import SwiftData

struct MoneyListComponent: View {
    var moneys:[Money] = []
    var body: some View {
        List {
            ForEach(moneys) { money in
                NavigationLink {
                    Text("Item at \(money.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                } label: {
                    Text(String(money.price))
                    Text(money.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                }
            }
        }
    }
}

#Preview {
    MoneyListComponent()
        .modelContainer(for: Money.self)
}
