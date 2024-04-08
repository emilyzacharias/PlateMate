import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Tab = .clipboard
    @ObservedObject var userPreferences: UserPreferences
    @StateObject var menuRecipes: MenuRecipes = MenuRecipes()
    @ObservedObject var recipeData: RecipeData = RecipeData()
    @State var username: String
    
    
    var body: some View {
        ZStack {
           // VStack {
                TabView(selection: $selectedTab) {
                    if selectedTab == .bookmark {
                        SavedRecipesView(recipeData: recipeData)
                    }
                    if selectedTab == .folder { 
                        BrowseRecipesView()
                            
                    }
                    if selectedTab == .clipboard {
                        GenerateRecipesView(menuRecipes: menuRecipes, recipeData: recipeData, userPreferences: userPreferences, userName: username)
                    }
                    if selectedTab == .cart {
                        ShoppingListView(menuRecipes: menuRecipes)
                    }
                    if selectedTab == .gearshape {
                        PreferencesView(username: $username, userPreferences: userPreferences)
                    }
                }
                
            
                
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
            
        } //ZStack */
        
    }
}


enum Tab: String, CaseIterable {
    case bookmark //bookmarked recipes
    case folder //browse
    case clipboard
    case cart //shopping list
    case gearshape //settings
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                        //.foregroundColor(selectedTab == tab ? Color(.black) : Color("mediumGray"))
                        .font(.system(size: 25))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
                
            }
            .frame(width: nil, height: 60)
            .background(Color("background"))
        }
    }
}



struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.black)
            .padding()
            .background(Color.orange)
            .cornerRadius(10)
    }
}
    
