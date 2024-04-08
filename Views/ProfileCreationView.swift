//
//  ProfileCreationView.swift
//
//
//  Created by Emily Zacharias on 2/18/24.
//

/*
 This view is where the user first creates their profile when the app launches.
 */
import SwiftUI

struct ProfileCreationView: View {
    @State private var username: String = ""
    @ObservedObject var userPreferences: UserPreferences
    
    var body: some View {
        ZStack {
            Color("background")
            
            ScrollView {
                
                Text("Welcome to Plate Mate")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Text("Plate Mate makes creating weekly menus and shopping lists easy. Plate Mate automatically selects 5 recipes for your weekly menu using a special algorithm that chooses recipes with common ingredients, saving you time, money, and reducing food waste.")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.vertical, 20)
                Spacer()
                
                Text("Please enter your first name below.")
                
                TextField(
                    "First name",
                    text: $username
                )
                
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.black), lineWidth: 2)
                )
                .padding(.horizontal, 5)
                .padding(.vertical, 20)
                
                
                Text("If you have any dietary restrictions that you would like us to filter out of all your generated menus, please select them below. Feel free to adjust these at any time in the settings tab. You can still view all recipes, regardless of restrictions, in the browse tab.")
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: RestrictionsSelectView(userPreferences: userPreferences)) {
                    Text("Select dietary restrictions")
                        .bold()
                    
                }
                .padding(.vertical, 20)
                
                
                Text("Now, all you have to do is click the button below to create your first set of recipes!")
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                NavigationLink(destination: ContentView(userPreferences: userPreferences, username: username).navigationBarHidden(true)) {
                    Text("CREATE MY MENU")
                    
                }
                .padding(.vertical, 20)
                .listRowInsets(EdgeInsets())
                .buttonStyle(CustomButtonStyle())
                Spacer()
            }
            .padding(.vertical, 80)
            .padding(.horizontal, 20)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
}

/*
 #Preview {
 ProfileCreationView()
 } */
