//
//  BrowseRecipesView.swift
//  PlateMate
//
//  Created by Emily Zacharias on 2/6/24.
//

/*
 This view is where a user can view all of the recipes in the app. 
 */
import SwiftUI

struct BrowseRecipesView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Color("background")
            VStack (alignment: .leading, spacing: 0) {
                Text("Browse")
                    .font(.title)
                    .bold()
                    .padding(.leading, 30)
                    .padding(.top, 10)
                    
                SearchBar(text: $searchText)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(RecipeData.recipes.filter {
                            searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText)
                        }) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                BrowseRecipeUI(recipe: recipe)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 60)
                }
                
            }
            .padding(.vertical, 50)
            //.padding(.horizontal, 20)
            .ignoresSafeArea()
        }
        .padding(.bottom, 20)
        .ignoresSafeArea()
        
        
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.white))
                .cornerRadius(8)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.black), lineWidth: 2)
                )
                .padding([.leading, .trailing], 8)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

struct BrowseRecipeUI: View {
    var imageName: String = "cacio"
    var recipe: Recipe = RecipeData.getRandomRecipe(excludedAllergens: [])
    
    var body: some View {
        VStack (alignment: .center, spacing: 0) {
                Image(recipe.image)
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(width: 150, height: 150)
                    .cornerRadius(12)
                    .padding(.top, 10)
                
                
                Text(recipe.name)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .background(Color.white)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    .foregroundColor(.black)


        }
        .frame(width: 170, height: 190)
        .background(.white)
        .cornerRadius(15)
        .shadow(color: Color("navy").opacity(0.15), radius: 4, x: 0, y: 4)
        
        
    }
}

#Preview {
    BrowseRecipeUI()
}
