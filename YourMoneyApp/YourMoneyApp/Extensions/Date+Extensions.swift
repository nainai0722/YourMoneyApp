//
//  Date+Extensions.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/03/04.
//

import SwiftUI

struct Date_Extensions: View {
    var body: some View {
        let nowTimeString = Date().formattedString
        Text(nowTimeString)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM dd HH:mm"
        return formatter.string(from: self)
    }
}


#Preview {
    Date_Extensions()
}
