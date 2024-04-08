//
//  RestrictionsSelectView.swift
//
//
//  Created by Emily Zacharias on 2/18/24.
//

import SwiftUI

//This is where a user can select their dietary restrictions.

struct RestrictionsSelectView: View {
    
    @ObservedObject var userPreferences: UserPreferences
    
    var body: some View {
        ZStack {
            Color("background")
            VStack {
                Text("Select ingredients to filter out of generated menus.")
                    .padding(.horizontal, 20)
                Form {
                    Section() {
                        
                        Toggle("meat", isOn: $userPreferences.meatRestrict)
                        Toggle("dairy", isOn: $userPreferences.dairyRestrict)
                        Toggle("fish", isOn: $userPreferences.fishRestrict)
                        Toggle("nuts", isOn: $userPreferences.nutsRestrict)
                        Toggle("eggs", isOn: $userPreferences.eggsRestrict)
                    }
                }
                .tint(Color("orange"))
                .scrollContentBackground(.hidden)
                .padding(.top, 20)
                .scrollDisabled(true)
                Text("You may need to remake the menu for changes to take effect.")
                    .padding(.horizontal, 20)
            }
            .padding(.vertical, 200)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
