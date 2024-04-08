//
//  GenerateRecipesView.swift
//  PlateMate
//
//  Created by Emily Zacharias on 2/6/24.
//

import SwiftUI

/*
 This view is the "home" view, and displays the user's menu that it generates.
 */
struct GenerateRecipesView: View {
    @ObservedObject var menuRecipes: MenuRecipes
    @ObservedObject var recipeData: RecipeData
    @ObservedObject var userPreferences: UserPreferences
    @State var showingConfirmation = false
    @State var showingRecipes = true
    
    var userName: String
    
    var body: some View {
        ZStack {
            Color("background")
            ScrollView {
                VStack (alignment: .leading) { //Header text
                    if (userName == "") {
                        Text("Hi!")
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                            .bold()
                    } else {
                        Text("Hi, " + userName + "!")
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                            .bold()
                    }
                    Text("Welcome to your menu this week.")
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                    Text("Ready for a new menu? Tap on the remake button at the bottom to move onto the next.")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)
                        .padding(.top, 5)
                        .foregroundColor(Color("mediumGray"))
                }
                .padding(.horizontal, 20.0)
                
                
                if (showingRecipes) {
                    ForEach(menuRecipes.recipes.indices, id: \.self) { index in
                        NavigationLink(destination: RecipeDetailView(recipe: menuRecipes.recipes[index])) {
                            RecipeUIView(recipe: menuRecipes.recipes[index], recipeData: recipeData, isFavorited: RecipeData.isFavorite(for: menuRecipes.recipes[index].name))
                        }
                        //print(RecipeData.isFavorite(for: menuRecipes.recipes[index].name))
                        
                    }
                } else {
                    ForEach(menuRecipes.recipes.indices, id: \.self) { index in
                        NavigationLink(destination: RecipeDetailView(recipe: menuRecipes.recipes[index])) {
                            RecipeUIView(recipe: menuRecipes.recipes[index], recipeData: recipeData, isFavorited: RecipeData.isFavorite(for: menuRecipes.recipes[index].name))
                        }
                        
                    }
                }
                
                
                VStack {
                    Button(action: {
                        showingConfirmation = true
                        showingRecipes = false
                    }, label: {
                        Text("Remake menu")
                    })
                    .alert(isPresented: $showingConfirmation) {
                        Alert(
                            title: Text("Confirm"),
                            message: Text("Are you sure you want to create a new menu? This will create a new shopping list as well."),
                            primaryButton: .default(Text("Yes")) {
                                
                                // Handle "Yes" button tap
                                menuRecipes.createMenu(excludedAllergens: getAllergens(userPreferences: userPreferences))
                                print("Recreated.")
                                showingRecipes = true
                            },
                            secondaryButton: .cancel(Text("No")) {
                                showingRecipes = true
                            }
                        )
                    }
                    .buttonStyle(CustomButtonStyle())
                    
                }
                .padding(.bottom, 50.0)
                
            }
            .padding(.vertical, 60.0)
        }
        .ignoresSafeArea()
        
    }
    
    func delete(at offsets: IndexSet) {
        menuRecipes.recipes.remove(atOffsets: offsets)
        //menuRecipes.updateIngredients()
    }
    
    func getAllergens(userPreferences: UserPreferences) -> [String] {
        var allergensArray: [String] = []
        if (userPreferences.meatRestrict) == true {
            allergensArray.append("meat")
        }
        if (userPreferences.dairyRestrict) == true {
            allergensArray.append("dairy")
        }
        if (userPreferences.fishRestrict) == true {
            allergensArray.append("fish")
        }
        if (userPreferences.nutsRestrict) == true {
            allergensArray.append("nuts")
        }
        if (userPreferences.eggsRestrict) == true {
            allergensArray.append("eggs")
        }
        return allergensArray
    }
}


struct RecipeUIView: View {
    var imageName: String = "cacio"
    var recipe: Recipe
    @ObservedObject var recipeData: RecipeData
    @State var isFavorited: Bool
    
    var body: some View {
        
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                Image(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 190)
                    .clipped()
                Text(recipe.name)
                    .font(.title3)
                    .background(.white)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    .bold()
                    .foregroundColor(.black)
                Text("\(recipe.shoppingIngredients.joined(separator: ", "))")
                    .font(.subheadline)
                    .background(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    .foregroundColor(Color("mediumGray"))
            }
            .padding(.bottom, 50.0)
            .frame(width: 350.0, height: 220.0)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: Color("navy").opacity(0.2), radius: 4, x: 0, y: 4)
            
            ZStack {
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 32))
                    .onAppear() {
                        isFavorited = RecipeData.isFavorite(for: recipe.name)
                    }
                Button(action: {
                    RecipeData.toggleFav(for: recipe.name)
                    isFavorited.toggle()
                    print(RecipeData.isFavorite(for: recipe.name))
                }, label: {
                    Image(systemName: isFavorited ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 32))
                })
            }
            
            
            
            .offset(x: 140, y: 39)
        }
        .padding(.bottom, 20)
        
    }
}

/*
 #Preview {
 RecipeUIView(recipe: RecipeData.getRandomRecipe(excludedAllergens: []))
 .background(Color.gray.edgesIgnoringSafeArea(.all))
 }
 */
