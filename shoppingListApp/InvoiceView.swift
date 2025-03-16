//
//  InvoiceView.swift
//  shoppingListApp
//
//  Created by jemish kevadiya on 2025-03-16.
//

import SwiftUI

struct InvoiceView: View {
    let items: [Item]
    let categories: [Category]
    @Environment(\.dismiss) private var dismiss
    
    let oliveGreen = Color(red: 85/255, green: 107/255, blue: 85/255)
    let offWhite = Color(red: 245/255, green: 245/255, blue: 220/255)
    
    var body: some View {
        VStack {
            Text("Invoice")
                .font(.largeTitle)
                .foregroundColor(oliveGreen)
            
            Text("Date: \(Date(), formatter: dateFormatter)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            List {
                ForEach(categories) { category in
                    let categoryItems = items.filter { $0.category == category.name }
                    if !categoryItems.isEmpty {
                        Section(header: Text(category.name).font(.headline)) {
                            ForEach(categoryItems) { item in
                                HStack {
                                    Text(item.name ?? "Unnamed Item")
                                    Spacer()
                                    Text(String(format: "$%.2f", item.price))
                                }
                            }
                            let subtotal = categoryItems.reduce(0) { $0 + $1.price }
                            let tax = subtotal * category.taxRate
                            let total = subtotal + tax
                            VStack(alignment: .trailing) {
                                Text("Subtotal: $\(String(format: "%.2f", subtotal))")
                                Text("Tax: $\(String(format: "%.2f", tax))")
                                Text("Total: $\(String(format: "%.2f", total))")
                                    .bold()
                            }
                        }
                    }
                }
                
                let overallSubtotal = items.reduce(0) { $0 + $1.price }
                let overallTax = categories.reduce(0) { sum, category in
                    let categoryItems = items.filter { $0.category == category.name }
                    let subtotal = categoryItems.reduce(0) { $0 + $1.price }
                    return sum + (subtotal * category.taxRate)
                }
                let grandTotal = overallSubtotal + overallTax
                
                Section(header: Text("Overall Totals").font(.headline)) {
                    Text("Subtotal: $\(String(format: "%.2f", overallSubtotal))")
                    Text("Tax: $\(String(format: "%.2f", overallTax))")
                    Text("Grand Total: $\(String(format: "%.2f", grandTotal))")
                        .bold()
                }
            }
            
            Button("Close") {
                dismiss()
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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
