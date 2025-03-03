//
//  shoppingListAppApp.swift
//  shoppingListApp
//
//  Created by jemish kevadiya on 2025-03-02.
//

import SwiftUI

@main
struct shoppingListAppApp: App {
    let persistenceController = PersistenceController.shared
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                             showSplash = false
                        }
                    }
            } else {
             CategoryListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
