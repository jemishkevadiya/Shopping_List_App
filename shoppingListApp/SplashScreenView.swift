//
//  SplashScreenView.swift
//  shoppingListApp
//
//  Created by jemish kevadiya on 2025-03-02.
//

import SwiftUI

struct SplashScreenView: View {
    // Custom colors
    let oliveGreen = Color(red: 85/255, green: 107/255, blue: 85/255) // Olive green
    let offWhite = Color(red: 245/255, green: 245/255, blue: 220/255) // Off white
    
    var body: some View {
        ZStack {
            offWhite.edgesIgnoringSafeArea(.all) // Set off-white background
            
            VStack {
                HStack {
                    Image(systemName: "cart.fill") // SF Symbol icon
                        .font(.system(size: 36, weight: .semibold, design: .rounded)) // Set font size and style
                        .foregroundColor(oliveGreen) // Set icon color to olive green
                    
                    Text("Shopping List")
                        .font(.system(size: 36, weight: .semibold, design: .rounded)) // Font style
                        .foregroundColor(oliveGreen) // Set title color to olive green
                }
                
                Text("Created by Team 54")
                    .font(.body)
                    .foregroundColor(oliveGreen.opacity(0.7)) // Lighter olive green for the subtitle
            }
            .padding()
        }
    }
}

#Preview {
    SplashScreenView()
}
