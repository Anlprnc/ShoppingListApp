import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @State private var newItemName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.itemsGroupedByCategory().keys.sorted(), id: \.self) { category in
                        Section(header: HStack {
                            Image(systemName: "cart.fill")
                                .foregroundColor(.green)
                            Text(category)
                                .font(.headline)
                        }) {
                            ForEach(viewModel.itemsGroupedByCategory()[category]!) { item in
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(item.isCompleted ? .green : .red)
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                viewModel.toggleCompletion(of: item)
                                            }
                                        }
                                    Text(item.name)
                                        .strikethrough(item.isCompleted)
                                        .font(.body)
                                    Spacer()
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(radius: 3))
                                .padding(.vertical, 5)
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
                .listStyle(InsetGroupedListStyle())
                
                HStack {
                    TextField("Add new item", text: $newItemName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .shadow(radius: 2)
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        withAnimation {
                            if !newItemName.isEmpty {
                                viewModel.addItem(newItemName)
                                newItemName = ""
                            }
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                    }
                    .padding(.leading, 10)
                }
                .padding()
            }

            .navigationTitle("Shopping List")
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .toolbar {
                if viewModel.items.contains(where: { $0.isCompleted }) {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                viewModel.removeCompletedItems()
                            }
                        }) {
                            Text("Delete Completed")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
