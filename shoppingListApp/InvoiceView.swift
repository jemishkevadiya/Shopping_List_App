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
    
    let accentColor = Color.blue
    
    var body: some View {
        VStack {
            Text("Invoice")
                .font(.system(size: 24))
            
            Text("Date: \(Date(), formatter: dateFormatter)")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            List {
                ForEach(categories) { category in
                    let categoryItems = items.filter { $0.category == category.name }
                    if !categoryItems.isEmpty {
                        Section(header: Text(category.name).font(.system(size: 16, weight: .medium))) {
                            ForEach(categoryItems) { item in
                                HStack {
                                    Text(item.name ?? "Unnamed Item")
                                        .font(.system(size: 14))
                                    Spacer()
                                    Text(String(format: "$%.2f", item.price))
                                        .font(.system(size: 14))
                                }
                                .padding(.vertical, 4)
                            }
                            let subtotal = categoryItems.reduce(0) { $0 + $1.price }
                            let tax = subtotal * category.taxRate
                            let total = subtotal + tax
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Subtotal: $\(String(format: "%.2f", subtotal))")
                                    .font(.system(size: 14))
                                Text("Tax: $\(String(format: "%.2f", tax))")
                                    .font(.system(size: 14))
                                Text("Total: $\(String(format: "%.2f", total))")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .padding(.vertical, 4)
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
                
                Section(header: Text("Overall Totals").font(.system(size: 16, weight: .medium))) {
                    Text("Subtotal: $\(String(format: "%.2f", overallSubtotal))")
                        .font(.system(size: 14))
                    Text("Tax: $\(String(format: "%.2f", overallTax))")
                        .font(.system(size: 14))
                    Text("Grand Total: $\(String(format: "%.2f", grandTotal))")
                        .font(.system(size: 14, weight: .bold))
                }
            }
            
            Button("Close") {
                dismiss()
            }
            .font(.system(size: 16))
            .padding(8)
            .foregroundColor(.white)
            .background(accentColor)
            .cornerRadius(4)
        }
        .padding()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
