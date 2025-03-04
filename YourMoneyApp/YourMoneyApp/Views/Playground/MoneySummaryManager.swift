//
//  MoneySummaryManager.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//


import SwiftData
import SwiftUI

// Viewは検証用に扱う
class MoneySummaryManager: ObservableObject {
    @Published var totalMoney: Int = 0
    @Published var incomeMoney: Int = 0
    @Published var expenseMoney: Int = 0
    
    private var moneys: [Money] = [] {
        didSet { calculate() }
    }
    
    init(moneys: [Money]) {
        self.moneys = moneys
        calculate()
    }
    
    func updateMoneys(_ newMoneys: [Money]) {
        self.moneys = newMoneys
    }
    
    private func calculate() {
        incomeMoney = moneys.filter { $0.moneyType == .income }.reduce(0) { $0 + $1.price }
        expenseMoney = moneys.filter { $0.moneyType == .expense }.reduce(0) { $0 + $1.price }
        totalMoney = incomeMoney - expenseMoney
    }
    
//    // 計算プロパティ
//    var totalMoney:Int{
//        return incomeMoney - expenseMoney
//    }
//    
//    // もらったお金の総額
//    var incomeMoney: Int {
//        let incomes = moneys.filter{ $0.moneyType == .income}.reduce(0) { $0+$1.price }
//        return incomes
//    }
//    var expenseMoney: Int {
//        let expense = moneys.filter{ $0.moneyType == .expense}.reduce(0) { $0+$1.price }
//        return expense
//    }
    
    // お手伝いの総額
    var familySupportMoney: Int {
        let familySupportMoneys = moneys.filter{ $0.moneyType == .income && $0.incomeType == .familySupport }.reduce(0) { $0+$1.price }
        return familySupportMoneys
    }
    
    // 毎月のお小遣いの総額
    var monthlyPayment: Int {
        let monthlyPaymentMoneys = moneys.filter{ $0.moneyType == .income && $0.incomeType == .monthlyPayment }.reduce(0) { $0+$1.price }
        return monthlyPaymentMoneys
    }
    
    
    // その他でもらったお金の総額
    var otherIncomeMoney: Int {
        let otherIncomeMoneys = moneys.filter{ $0.moneyType == .income && $0.incomeType == .other }.reduce(0) { $0+$1.price }
        return otherIncomeMoneys
    }
    
    // 指定したincomeTypeの総額
    func getIncomeTypeMoney(by incomeType:IncomeType) -> Int {
        let selectedIncomeTypeMoneys = moneys.filter{ $0.moneyType == .income && $0.incomeType == incomeType }.reduce(0){ $0+$1.price }
        return selectedIncomeTypeMoneys
    }
    
    func incomeMoneyByMonth(year: Int, month: Int) -> Int {
        let incomes = filterBy(year: year, month: month).filter{ $0.moneyType == .income}.reduce(0) { $0+$1.price }
        return incomes
    }
    
    func expenseMoneyByMonth(year: Int, month: Int) -> Int {
        let expense = filterBy(year: year, month: month).filter{ $0.moneyType == .expense }.reduce(0){ $0+$1.price }
        return expense
    }
    
    func filterBy(year: Int, month: Int) -> [Money] {
        let calendar = Calendar.current
        return moneys.filter {
            calendar.component(.year, from: $0.timestamp) == year &&
            calendar.component(.month, from: $0.timestamp) == month
        }
    }
}

