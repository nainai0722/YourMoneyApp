//
//  SummaryView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        MoneySummaryComponent(total: .constant(1000))
            .padding()
        
    }
}

#Preview {
    SummaryView()
}
