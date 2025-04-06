//
//  CategoryListView.swift
//  shoppingListApp
//
//  Created by jemish kevadiya on 2025-03-16.
//

import SwiftUI
import CoreData

struct CategoryListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: true)])
    private var categoryEntities: FetchedResults<CategoryEntity>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)])
    private var items: FetchedResults<Item>
    
    @State private var showAddCategory = false
    @State private var newCategoryName = ""
    @State private var newTaxRate = ""
    @State private var showInvoice = false
    @State private var showDuplicateAlert = false
    
    let oliveGreen = Color(red: 85/255, green: 107/255, blue: 85/255)
    let offWhite = Color(red: 245/255, green: 245/255, blue: 220/255)
    
    var body: some View {
        NavigationView {
            VStack {
                if categoryEntities.isEmpty {
                    Text("No categories. Tap + to add one.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(categoryEntities.map { Category(id: $0.id ?? UUID(), name: $0.name ?? "", taxRate: $0.taxRate) }) { category in
                            NavigationLink(destination: ContentView(category: category)) {
                                categoryRow(category: category)
                            }
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    if items.filter({ $0.category == category.name }).isEmpty {
                                        if let entity = categoryEntities.first(where: { $0.id == category.id }) {
                                            viewContext.delete(entity)
                                            try? viewContext.save()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, 10)
                }
                
                Spacer()
                
                let totals = calculateOverallTotals()
                VStack {
                    Text("Overall Total")
                        .font(.headline)
                        .foregroundColor(oliveGreen)
                    HStack {
                        Text("Subtotal: $\(String(format: "%.2f", totals.subtotal))")
                        Spacer()
                        Text("Tax: $\(String(format: "%.2f", totals.tax))")
                        Spacer()
                        Text("Total: $\(String(format: "%.2f", totals.total))")
                            .bold()
                    }
                    .foregroundColor(oliveGreen)
                    .padding()
                    .background(offWhite)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddCategory.toggle() }) {
                        Label("Add Category", systemImage: "plus.circle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(10)
                            .background(.green)
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
            }
            .sheet(isPresented: $showAddCategory) {
                VStack {
                    Text("Add New Category")
                        .font(.headline)
                        .foregroundColor(oliveGreen)
                    TextField("Category Name", text: $newCategoryName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Tax Rate (%)", text: $newTaxRate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.decimalPad)
                    Button("Add") {
                        if let taxRate = Double(newTaxRate), !newCategoryName.isEmpty {
                            let trimmedName = newCategoryName.trimmingCharacters(in: .whitespaces)
                            let existingCategory = categoryEntities.first(where: { $0.name?.lowercased() == trimmedName.lowercased() })
                            
                            if existingCategory != nil {
                                showDuplicateAlert = true
                            } else {
                                let newCategory = CategoryEntity(context: viewContext)
                                newCategory.id = UUID()
                                newCategory.name = trimmedName
                                newCategory.taxRate = taxRate / 100
                                try? viewContext.save()
                                newCategoryName = ""
                                newTaxRate = ""
                                showAddCategory = false
                            }
                        }
                    }
                    .padding()
                    .background(oliveGreen)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showDuplicateAlert) {
                    Alert(
                        title: Text("Duplicate Category"),
                        message: Text("A category with the name '\(newCategoryName)' already exists."),
                        dismissButton: .default(Text("OK")) {
                            newCategoryName = "" 
                            newTaxRate = ""
                        }
                    )
                }
            }
            .sheet(isPresented: $showInvoice) {
                InvoiceView(items: Array(items), categories: categoryEntities.map { Category(id: $0.id ?? UUID(), name: $0.name ?? "", taxRate: $0.taxRate) })
            }
        }
        .background(offWhite)
    }
    
    private func categoryRow(category: Category) -> some View {
        HStack {
            Image(systemName: "folder.fill")
                .foregroundColor(oliveGreen)
            VStack(alignment: .leading, spacing: 5) {
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(oliveGreen)
                Text("Tax Rate: \(String(format: "%.2f", category.taxRate * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            let itemCount = items.filter { $0.category == category.name }.count
            Text("\(itemCount) Items")
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
    }
    
    private func calculateOverallTotals() -> (subtotal: Double, tax: Double, total: Double) {
        var subtotal: Double = 0
        var tax: Double = 0
        
        let categoryList = categoryEntities.map { (name: $0.name ?? "", taxRate: $0.taxRate) }
        
        for item in items {
            let matchingCategories = categoryList.filter { $0.name == (item.category ?? "") }
            
            if let firstMatchingCategory = matchingCategories.first {
                let taxRate = firstMatchingCategory.taxRate
                let itemSubtotal = item.price
                let itemTax = itemSubtotal * taxRate
                subtotal += itemSubtotal
                tax += itemTax
            }
        }
        
        let total = subtotal + tax
        return (subtotal, tax, total)
    }
}
