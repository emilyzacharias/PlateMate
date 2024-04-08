//
//  WelcomeView.swift
//
//
//  Created by Emily Zacharias on 2/18/24.
//

import SwiftUI

//This is the first view when the user opens the app.
struct WelcomeView: View {
    @StateObject private var userPreferences = UserPreferences()
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 340)
                Text("Plate Mate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("we'll take dinner from here")
                    .font(.title2)
                    .padding(.top, 5)
                NavigationLink(destination: ProfileCreationView( userPreferences: userPreferences).navigationBarHidden(true)) {
                    Text("GET STARTED")
                        
                }
                .buttonStyle(CustomButtonStyle())
                .padding(.top, 58.0)
                
                Spacer()
                
            }
            
        }
        
        
        
    }
}
