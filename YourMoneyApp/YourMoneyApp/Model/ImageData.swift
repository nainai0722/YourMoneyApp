//
//  ImageData.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/18.
//

import Foundation
import SwiftData

enum ImageCategory: String, CaseIterable, Codable {
    case foodDrink = "food-drink"
    case life = "life"
    case school = "school"
}

@Model
final class ImageData: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var fileName: String
    var category: ImageCategory
    var isPinned: Bool
    var timestamp: Date
    
    init(fileName: String, category: ImageCategory, isPinned: Bool, timestamp: Date) {
        self.fileName = fileName
        self.category = category
        self.isPinned = isPinned
        self.timestamp = timestamp
    }
}
