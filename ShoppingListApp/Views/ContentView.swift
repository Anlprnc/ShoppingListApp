//
//  ContentView.swift
//  ShoppingListApp
//
//  Created by Anıl on 16.09.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @State private var newItemName: String = ""
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.itemsGroupedByCategory().keys.sorted(), id: \.self) { category in
                        Section(header: Text(category)) {
                            ForEach(viewModel.itemsGroupedByCategory()[category]!) { item in
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill": "circle")
                                        .onTapGesture {
                                            viewModel.toggleCompletion(of: item)
                                        }
                                }
                                .padding()
                                .background(item.isCompleted ? Color.gray.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                            }
                            .onDelete { indexSet in
                                if let index = indexSet.first {
                                    let categoryItems = viewModel.itemsGroupedByCategory()[category]!
                                    let itemToDelete = categoryItems[index]
                                    viewModel.deleteItem(item: itemToDelete)
                                }
                            }
                        }
                    }
                 }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                
                HStack {
                    TextField("Add new item", text: $newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        withAnimation {
                            if !newItemName.isEmpty {
                                viewModel.addItem(newItemName)
                                newItemName = ""
                            }
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.leading, 10)
                }
                .padding()
            }
            .navigationTitle("Shopping List")
        }
    }
}

#Preview {
    ContentView()
}
