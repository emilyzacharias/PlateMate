/*
 This app allows users to create a random menu or one based off of 1-2 recipe of their choosing. Then it uses an algorithm to choose 3-4 other recipes that use the same ingredients, to make a cost effective grocery trip that also limits food waste.
 */

import SwiftUI

@main
struct MyApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
