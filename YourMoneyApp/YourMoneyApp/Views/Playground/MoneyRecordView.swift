//
//  MoneyRecordView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/02.
//

import SwiftUI
import SwiftData

struct MoneyRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var moneys: [Money]
    @State var totalMoney: Int = 0
    
    var body: some View {
        NavigationSplitView {
            MoneySummaryComponent(total: $totalMoney)
                .onAppear {
                    fetchTotalMoney()
                }
            List {
                ForEach(moneys) { money in
                    NavigationLink {
                        Text("Item at \(money.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        MoneyInfoCell(money: money)
                    }
                }
                .onDelete(perform: deleteMoneys)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addMoney) {
                        Label("Add Money", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: addMoneyByDate) {
                        Label("Add Money By Date", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an money")
        }
    }
    
    private func fetchTotalMoney() {
        let fetchDescriptor = FetchDescriptor<Money>()
        if let allMoneys = try? modelContext.fetch(fetchDescriptor) {
            let expense = allMoneys.filter { $0.moneyType == .expense }.reduce(0) { $0 + $1.price }
            let income = allMoneys.filter { $0.moneyType == .income }.reduce(0) { $0 + $1.price }
            totalMoney = income - expense
            print("総額の再計算\(totalMoney)")
        }
    }

    private func addMoney() {
        withAnimation {
            let newItem = Money(price: 100, moneyType: .income, incomeType: .monthlyPayment, memo: "メモメモ", timestamp: Date())
            modelContext.insert(newItem)
            fetchTotalMoney()
        }
    }
    
    func addMoneyByDate() {
        let calendar = Calendar.current
        if let specificDate = calendar.date(from: DateComponents(year: 2025, month: 2, day: 1)) {
            addMoneyByDate(by: specificDate)
        }
    }
    
    private func addMoneyByDate(by date: Date) {
        withAnimation {
            
            let newItem = Money(price: 100, moneyType: .income, incomeType: .familySupport, memo: "メモメモ", timestamp: date)
            modelContext.insert(newItem)
            fetchTotalMoney()
        }
    }
    
    private func deleteMoneys(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(moneys[index])
                fetchTotalMoney()
            }
        }
    }
}

#Preview {
    MoneyRecordView()
        .modelContainer(for: Money.self)
}

