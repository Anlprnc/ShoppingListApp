//
//  ShoppingItem.swift
//  ShoppingListApp
//
//  Created by Anıl on 16.09.2024.
//

import Foundation

struct ShoppingItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var isCompleted: Bool = false
    var category: String
}
