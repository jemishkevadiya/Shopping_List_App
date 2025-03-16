//
//  Category.swift
//  shoppingListApp
//
//  Created by jemish kevadiya on 2025-03-16.
//

import Foundation

struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    var taxRate: Double 

    init(id: UUID = UUID(), name: String, taxRate: Double) {
        self.id = id
        self.name = name
        self.taxRate = taxRate
    }
}
