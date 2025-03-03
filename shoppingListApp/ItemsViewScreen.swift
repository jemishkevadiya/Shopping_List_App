//
//  ItemsViewScreen.swift
//  shoppingListApp
//
//  Created by DEEP LAKHANI on 2025-03-02.
//

import SwiftUI

struct IdentifiableItem: Identifiable {
    var id = UUID()
    var name: String
    var taxRate: Double
    var totalItems: Int
}

struct ItemListView: View {
    var category: IdentifiableString
    @State private var showAddItem = false
    @State private var newItemName = ""
    @State private var newItemTaxRate: String = ""
    @State private var newItemTotalItems: String = ""
    
    @State private var showEditItem = false
    @State private var selectedItem: IdentifiableItem?
    
    @State private var showInvoice = false
    @State private var items = [
        IdentifiableItem(name: "Milk", taxRate: 10, totalItems: 3),
        IdentifiableItem(name: "Laptop", taxRate: 15, totalItems: 2)
    ]

    let oliveGreen = Color(red: 85/255, green: 107/255, blue: 85/255)
    let offWhite = Color(red: 245/255, green: 245/255, blue: 220/255)

    var body: some View {
        VStack {
            Text("Items for \(category.value)")
                .font(.title)
                .foregroundColor(oliveGreen)
                .padding()

            List {
                ForEach(items) { item in
                    NavigationLink(destination: Text("\(item.name) Details")) {
                        itemRow(item: item)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            deleteItem(item)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding(.top, 10)

            Spacer()
        }
        .navigationTitle("Items")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddItem.toggle() }) {
                    Label("Add Item", systemImage: "plus.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(10)
                        .background(oliveGreen)
                        .cornerRadius(10)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showInvoice.toggle() }) {
                    Label("Invoice", systemImage: "doc.text.fill")
                        .foregroundColor(oliveGreen)
                        .font(.title2)
                        .padding(10)
                        .background(oliveGreen.opacity(0.1))
                        .cornerRadius(10)
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if let selected = selectedItem {
                        newItemName = selected.name
                        newItemTaxRate = String(selected.taxRate)
                        newItemTotalItems = String(selected.totalItems)
                        showEditItem.toggle()
                    }
                }) {
                    Label("Edit", systemImage: "pencil.circle.fill")
                        .foregroundColor(oliveGreen)
                        .font(.title2)
                        .padding(10)
                        .background(oliveGreen.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showAddItem) {
            VStack {
                Text("Add New Item")
                    .font(.title)
                    .padding()

                TextField("Item Name", text: $newItemName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Tax Rate", text: $newItemTaxRate)
                    .keyboardType(.decimalPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Total Items", text: $newItemTotalItems)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Save") {
                    if let taxRate = Double(newItemTaxRate), let totalItems = Int(newItemTotalItems) {
                        let newItem = IdentifiableItem(name: newItemName, taxRate: taxRate, totalItems: totalItems)
                        items.append(newItem)
                    }
                    showAddItem.toggle()
                }
                .padding()
                .background(oliveGreen)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top)

                Spacer()
            }
            .padding()
            .background(offWhite)
            .cornerRadius(20)
            .shadow(radius: 5)
        }
        .sheet(isPresented: $showEditItem) {
            VStack {
                Text("Edit Item")
                    .font(.title)
                    .padding()

                TextField("Item Name", text: $newItemName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Tax Rate", text: $newItemTaxRate)
                    .keyboardType(.decimalPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Total Items", text: $newItemTotalItems)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Save") {
                    if let selected = selectedItem,
                       let taxRate = Double(newItemTaxRate),
                       let totalItems = Int(newItemTotalItems) {
                        if let index = items.firstIndex(where: { $0.id == selected.id }) {
                            items[index].name = newItemName
                            items[index].taxRate = taxRate
                            items[index].totalItems = totalItems
                        }
                    }
                    showEditItem.toggle()                }
                .padding()
                .background(oliveGreen)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top)

                Spacer()
            }
            .padding()
            .background(offWhite)
            .cornerRadius(20)
            .shadow(radius: 5)
        }

        .sheet(isPresented: $showInvoice) {
            VStack {
                Text("Dummy Invoice")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(oliveGreen)

                Text("Invoice Number: 12345")
                Text("Date: March 2025")
                Text("Total: $150.00")

                Spacer()

                Button("Close") {
                    showInvoice.toggle()
                }
                .padding()
                .background(oliveGreen)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .background(offWhite)
            .cornerRadius(20)
            .shadow(radius: 5)
        }
    }

    private func itemRow(item: IdentifiableItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(oliveGreen)
                Text("Tax Rate: \(item.taxRate)%")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(item.totalItems) Items")
                .font(.subheadline)
                .padding(8)
                .background(oliveGreen.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(oliveGreen)
        }
        .padding(12)
        .background(offWhite)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.vertical, 5)
        .onTapGesture {
            selectedItem = item 
        }
    }

    private func deleteItem(_ item: IdentifiableItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(category: IdentifiableString(value: "Groceries", taxRate: 10, totalItems: 5))
    }
}
