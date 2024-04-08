//
//  PreferencesView.swift
//  PlateMate
//
//  Created by Emily Zacharias on 2/6/24.
//

import SwiftUI
/*
 This view is where the user can change their name and dietary restrictions once the app has launched.
 */
struct PreferencesView: View {
    @Binding var username: String
    @ObservedObject var userPreferences: UserPreferences
    
    var body: some View {
        ZStack {
            Color("background")
            VStack (alignment: .leading) {
                //Spacer()
                Text("Settings")
                    .font(.title)
                    .bold()
                    .padding(.leading, 30)
                    .padding(.top, 50)
                    .padding(.vertical, 10)
                Form {
                    Section() {
                        TextField(
                            "First name",
                            text: $username
                        )
                        
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        NavigationLink(destination: RestrictionsSelectView(userPreferences: userPreferences)) {
                            Text("Select dietary restrictions")
                        }
                    }
                     
                    
                }
                .scrollContentBackground(.hidden)
                
                Spacer()
            }
            
        }
        .ignoresSafeArea()
        
    }
}

