//
//  ContentView.swift
//  shoppingListApp
//
//  Created by jemish kevadiya on 2025-03-02.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let category: Category
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest private var items: FetchedResults<Item>
    
    @State private var showAddItem = false
    @State private var newItemName = ""
    @State private var newItemPrice = ""
    
    init(category: Category) {
        self.category = category
        _items = FetchRequest<Item>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
            predicate: NSPredicate(format: "category == %@", category.name)
        )
    }
    
    var body: some View {
        VStack {
            if items.isEmpty {
                Text("No items in this category. Tap + to add one.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    Section(header: Text("Items in \(category.name)")) {
                        ForEach(items) { item in
                            HStack {
                                Text(item.name ?? "Unnamed Item")
                                Spacer()
                                Text(String(format: "$%.2f", item.price))
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                    Section(header: Text("Totals")) {
                        let subtotal = items.reduce(0) { $0 + $1.price }
                        let tax = subtotal * category.taxRate
                        let total = subtotal + tax
                        
                        HStack {
                            Text("Subtotal:")
                            Spacer()
                            Text(String(format: "$%.2f", subtotal))
                        }
                        HStack {
                            Text("Tax (\(String(format: "%.2f", category.taxRate * 100))%):")
                            Spacer()
                            Text(String(format: "$%.2f", tax))
                        }
                        HStack {
                            Text("Total:")
                                .bold()
                            Spacer()
                            Text(String(format: "$%.2f", total))
                                .bold()
                        }
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: { showAddItem.toggle() }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddItem) {
            VStack {
                Text("Add New Item")
                    .font(.headline)
                    .foregroundColor(Color(red: 85/255, green: 107/255, blue: 85/255))
                TextField("Item Name", text: $newItemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Price ($)", text: $newItemPrice)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.decimalPad)
                Button("Add") {
                    if let price = Double(newItemPrice), !newItemName.isEmpty {
                        addItem(name: newItemName, price: price)
                        newItemName = ""
                        newItemPrice = ""
                        showAddItem = false
                    }
                }
                .padding()
                .background(Color(red: 85/255, green: 107/255, blue: 85/255))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func addItem(name: String, price: Double) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.category = category.name
            newItem.name = name
            newItem.price = price
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
