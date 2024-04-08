//
//  SavedRecipesView.swift
//  PlateMate
//
//  Created by Emily Zacharias on 2/6/24.
//

import SwiftUI

//This is where a user can view saved recipes.
struct SavedRecipesView: View {
    
    @ObservedObject var recipeData: RecipeData
    
    
    var body: some View {
        ZStack {
            Color("background")
            // NavigationView {
            VStack (alignment: .leading, spacing: 0) {
                Text("Saved recipes")
                    .font(.title)
                    .bold()
                    .padding(.leading, 10)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                ScrollView {
                    ForEach(RecipeData.savedRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            SavedRecipeUI(recipe: recipe)
                        }
                    }
                    
                }
                .padding(.bottom, 60)
            }
            .padding(.vertical, 50)
            //.padding(.horizontal, 20)
            .ignoresSafeArea()
        }
        .padding(.bottom, 20)
        .ignoresSafeArea()
    }
}


struct SavedRecipeUI: View {
    var imageName: String = "cacio"
    var recipe: Recipe = RecipeData.getRandomRecipe(excludedAllergens: [])
    
    var body: some View {
        HStack (alignment: .top, spacing: 0) {
            VStack {
                Spacer()
                Image(recipe.image)
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(width: 130, height: 130)
                    .cornerRadius(15)
                Spacer()
            }
              
            
            VStack (alignment: .leading) {
                Text(recipe.name)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .background(Color.white)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .foregroundColor(.black)
                    .bold()
                
                Text("\(recipe.shoppingIngredients.joined(separator: ", "))")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .background(.white)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            Spacer()
        }
        .padding(.leading, 15)
        .frame(width: 350.0, height: 160.0)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color("navy").opacity(0.2), radius: 4, x: 0, y: 4)
        
        
    }
}

#Preview {
    SavedRecipeUI()
}
