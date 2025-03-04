//
//  MoneySummaryView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/03.
//

import SwiftUI
import SwiftData

struct MoneySummaryView: View {
    @Query private var moneys: [Money]
    @State var total: Int = 0
    var body: some View {
        ZStack {
            Rectangle().fill(Color.green)
                .cornerRadius(20)
            VStack(alignment:.leading) {
                HStack {
                    Text("おこづかい")
                        .font(.headline)
                    Spacer()
                    Text(currentDateString + "現在")
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.bottom, 20)
                Text("\(total)円")
                    .font(.title)
            }
            .foregroundStyle(.white)
            .padding(.horizontal,40)
            Image("money_bag_color")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100 )
                .offset(x: 80, y: 40)
        }
        .frame(height: 200)
        .padding(20)
    }
    
    var currentDateString:String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM dd HH:mm"
        let formattedDate = formatter.string(from: Date())
        return formattedDate
    }
}

#Preview {
    MoneySummaryView()
        .modelContainer(for: Money.self)
}
