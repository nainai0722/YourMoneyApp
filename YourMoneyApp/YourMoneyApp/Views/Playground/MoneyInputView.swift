//
//  MoneyInputView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/05.
//

import SwiftUI

struct MoneyInputView: View {
    @Binding var isShowingSheet: Bool
    @Environment(\.modelContext) private var modelContext
    var moneyType: MoneyType = .expense
    let moneyBottonContents : [Int] = [100,200,400,300,500,700,1000]
    @State var inputPrice: String = ""
    @State var selectedIncomeType: IncomeType?
    @State var selectedExpenseType: ExpenseType?
    @State var selectedDate: Date = Date()
    @State var isShowCalendar:Bool = false
    
    var body: some View {
        VStack{
            Text("記録する")
            
            if moneyType == .income {
                Text("おこづかいの種類")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(IncomeType.allCases, id: \.self) { incomeType in
                            Button(action: {
                                
                                selectedIncomeType = incomeType
                            } ) {
                                Text(incomeType.rawValue)
                                    .foregroundColor(incomeType == selectedIncomeType ? .white :.blue)
                                    .modifier(BorderedTextChangeColor(isSelected: incomeType == selectedIncomeType))
                            }
                        }
                    }
                }
            } else {
                Text("何に使った？")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(ExpenseType.allCases, id: \.self) { expenseType in
                            Button(action: {
                                selectedExpenseType = expenseType
                            } ) {
                                Text(expenseType.rawValue)
                                    .foregroundColor(expenseType == selectedExpenseType ? .white :.blue)
                                    .modifier(BorderedTextChangeColor(isSelected: expenseType == selectedExpenseType))
                            }
                        }
                    }
                }
            }
            
            
            VStack {
                HStack(spacing:0) {
                    TextField("金額を入力", text: $inputPrice)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing) // テキスト入力も左寄せ
                        .font(.system(size: 30))
                        .padding(.trailing, 30)
                    Text("円")
                }
                .padding(.horizontal)
                Rectangle()
                    .frame(height: 1) // 線の太さ
                    .foregroundColor(.blue) // 線の色
                    .padding(.horizontal)
            }
            .padding()
            
            Button(action: {
                isShowCalendar.toggle()
            }){
                Text("\(selectedDate.formattedYearMonthDayString)")
                Text("日付を変更する")
            }
                
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(moneyBottonContents, id: \.self) { content in
                        Button(action: {
                            inputPrice = String(content)
                        } ) {
                            Text("\(content)円")
                                .modifier(BorderedTextModifier())
                        }
                    }
                }
            }
    
            Button("追加する") {
                insertMoneyItem()
                
                isShowingSheet = false
            }
            .buttonStyle(.borderedProminent)
            .buttonStyle(.bordered)
        }
        .overlay(){
            selectDateView(selectedDate: $selectedDate, isShowCalendar: $isShowCalendar)
        }
    }
    func insertMoneyItem() {
        // お小遣いを追加する
        if let priceValue = Int(inputPrice), let _ = selectedIncomeType {
            let newItem = Money(price: priceValue, moneyType: moneyType, incomeType: selectedIncomeType, memo: "メモメモ", timestamp: Date())
            modelContext.insert(newItem)
        }
        // 何に使ったか
        if let priceValue = Int(inputPrice), let _ = selectedExpenseType {
            let newItem = Money(price: priceValue, moneyType: moneyType, expenseType: selectedExpenseType, memo: "メモメモ", timestamp: Date())
            modelContext.insert(newItem)
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
        }
    }
    
}

#Preview {
    MoneyInputView(isShowingSheet: .constant(true))
}

import SwiftUI

struct BorderedTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding() // テキストの周りに余白を追加
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2) // 枠線を追加
                    )
            )
    }
}

struct BorderedTextChangeColor: ViewModifier {
    var isSelected: Bool
    func body(content: Content) -> some View {
        content
            .padding() // テキストの周りに余白を追加
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.blue : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color.white : Color.blue, lineWidth: 2)
                    )
            )
    }
}


struct selectDateView: View {
    @Binding var selectedDate: Date
    @Binding var isShowCalendar: Bool
    var body: some View {
        ZStack {
            VStack {
                Text("変更する日付を選ぶ")
                DatePicker(
                    "\(selectedDate.formattedYearMonthDayString)",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                Button(action:{
                    isShowCalendar = false
                }){
                    Text("閉じる")
                }
            }
            .frame(width: 300, height: 400)
            .padding()
            .cornerRadius(0.5)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(isShowCalendar ? 1 : 0)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.gray.opacity(0.4).edgesIgnoringSafeArea(.all))
        .opacity(isShowCalendar ? 1 : 0)
    }
}
