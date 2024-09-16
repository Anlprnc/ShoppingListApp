//
//  ShoppingListViewModel.swift
//  ShoppingListApp
//
//  Created by Anıl on 16.09.2024.
//

import Foundation
import UserNotifications

class ShoppingListViewModel: ObservableObject {
    @Published var items: [ShoppingItem] = [] {
        didSet {
            saveItems()
        }
    }
    
    let itemsKey = "shopping_items"
    
    init() {
        loadItems()
    }
    
    func saveItems() {
        if let encodedItems = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedItems, forKey: itemsKey)
        }
    }
    
    func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: itemsKey) {
            if let decodedItems = try? JSONDecoder().decode([ShoppingItem].self, from: savedItems) {
                items = decodedItems
            }
        }
    }
    
    func addItem(_ name: String) {
        let newItem = ShoppingItem(name: name, category: "Others")
        items.append(newItem)
    }
    
    func deleteItem(item: ShoppingItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func toggleCompletion(of item: ShoppingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
    
    func itemsGroupedByCategory() -> [String: [ShoppingItem]] {
        Dictionary(grouping: items, by: { $0.category })
    }
    
    func removeCompletedItems() {
        items.removeAll { $0.isCompleted }
    }
    
    func scheduleNotification(for item: ShoppingItem) {
        let content = UNMutableNotificationContent()
        content.title = "Shopping List"
        content.body = "\(item.name) don't forget the item!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
