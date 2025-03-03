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
}

struct CategoryListView: View {
    @State private var showAddCategory = false
    @State private var selectedCategory: IdentifiableString?
    @State private var showInvoice = false

    let oliveGreen = Color(red: 85/255, green: 107/255, blue: 85/255)
    let offWhite = Color(red: 245/255, green: 245/255, blue: 220/255)

    let categories = [
        IdentifiableString(value: "Groceries"),
        IdentifiableString(value: "Electronics"),
        IdentifiableString(value: "Clothing"),
        IdentifiableString(value: "Furniture")
    ]

    var body: some View {
        NavigationView {
            VStack {

                List {
                    ForEach(categories) { category in
                        NavigationLink(destination: Text("\(category.value) Items List")) {
                            categoryRow(category: category)
                        }
                        .swipeActions {
                            Button("Delete", role: .destructive) {
                                print("Delete \(category.value)")
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
                ToolbarItem(placement: .principal) {
                    Text("Categories")
                        .font(.headline)
                        .foregroundColor(oliveGreen)
                }

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
                Text("Add Category View")
                    .font(.headline)
                    .foregroundColor(oliveGreen)
            }
            .sheet(item: $selectedCategory) { category in
                Text("Edit Category: \(category.value)")
                    .font(.headline)
                    .foregroundColor(oliveGreen)
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
                Text("Sample Tax Rate: 10%")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("0 Items")
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
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
