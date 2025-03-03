//
//  HomeScreen.swift
//  shoppingListApp
//
//  Created by jemish kevadiya on 2025-03-02.
//

import SwiftUI

struct IdentifiableString: Identifiable {
    var id = UUID()
    var value: String
    var taxRate: Double
    var totalItems: Int
}

struct CategoryListView: View {
    @State private var showAddCategory = false
    @State private var newCategoryName = ""
    @State private var newCategoryTaxRate: String = ""
    @State private var newCategoryTotalItems: String = ""
    
    @State private var showEditCategory = false
    @State private var selectedCategory: IdentifiableString?
    
    @State private var categories = [
        IdentifiableString(value: "Groceries", taxRate: 10, totalItems: 5),
        IdentifiableString(value: "Electronics", taxRate: 15, totalItems: 10)
    ]
    
    @State private var showInvoice = false

    let oliveGreen = Color(red: 85/255, green: 107/255, blue: 85/255)
    let offWhite = Color(red: 245/255, green: 245/255, blue: 220/255)

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(categories) { category in
                        NavigationLink(destination: ItemListView(category: category)) {
                            categoryRow(category: category)
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                deleteCategory(category)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.top, 10)

                Spacer()
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddCategory.toggle() }) {
                        Label("Add Category", systemImage: "plus.circle.fill")
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
                        if let selected = selectedCategory {
                            newCategoryName = selected.value
                            newCategoryTaxRate = String(selected.taxRate)
                            newCategoryTotalItems = String(selected.totalItems)
                            showEditCategory.toggle()
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
            .sheet(isPresented: $showAddCategory) {
                VStack {
                    Text("Add New Category")
                        .font(.title)
                        .padding()

                    TextField("Category Name", text: $newCategoryName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Tax Rate", text: $newCategoryTaxRate)
                        .keyboardType(.decimalPad)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Total Items", text: $newCategoryTotalItems)
                        .keyboardType(.numberPad)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Save") {
                        if let taxRate = Double(newCategoryTaxRate), let totalItems = Int(newCategoryTotalItems) {
                            let newCategory = IdentifiableString(
                                value: newCategoryName,
                                taxRate: taxRate,
                                totalItems: totalItems
                            )
                            categories.append(newCategory)
                        }
                        showAddCategory.toggle()
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
            .sheet(isPresented: $showEditCategory) {
                VStack {
                    Text("Edit Category")
                        .font(.title)
                        .padding()

                    TextField("Category Name", text: $newCategoryName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Tax Rate", text: $newCategoryTaxRate)
                        .keyboardType(.decimalPad)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Total Items", text: $newCategoryTotalItems)
                        .keyboardType(.numberPad)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Save") {
                        if let selected = selectedCategory,
                           let taxRate = Double(newCategoryTaxRate),
                           let totalItems = Int(newCategoryTotalItems) {
                            if let index = categories.firstIndex(where: { $0.id == selected.id }) {
                                categories[index].value = newCategoryName
                                categories[index].taxRate = taxRate
                                categories[index].totalItems = totalItems
                            }
                        }
                        showEditCategory.toggle()
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
        .background(offWhite)
        .cornerRadius(20)
        .padding()
    }

    private func categoryRow(category: IdentifiableString) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(category.value)
                    .font(.headline)
                    .foregroundColor(oliveGreen)
                Text("Tax Rate: \(category.taxRate)%")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(category.totalItems) Items")
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
            selectedCategory = category 
        }
    }

    private func deleteCategory(_ category: IdentifiableString) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories.remove(at: index)
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
