//
//  SplashScreenView.swift
//  shoppingListApp
//
//  Created by jemish kevadiya on 2025-03-02.
//

import SwiftUI

struct SplashScreenView: View {
    let oliveGreen = Color(red: 85/255, green: 107/255, blue: 85/255)
    let offWhite = Color(red: 245/255, green: 245/255, blue: 220/255)
    
    var body: some View {
        ZStack {
            offWhite.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundColor(oliveGreen)
                    
                    Text("Shopping List")
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundColor(oliveGreen)
                }
                
                Text("Created by Team 54")
                    .font(.body)
                    .foregroundColor(oliveGreen.opacity(0.7))  
            }
            .padding()
        }
    }
}

#Preview {
    SplashScreenView()
}
