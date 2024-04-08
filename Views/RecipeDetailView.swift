//
//  SwiftUIView.swift
//  
//
//  Created by Emily Zacharias on 2/19/24.
//

import SwiftUI

/*
 This view displays details about each recipe.
 */
struct RecipeDetailView: View {
    var recipe: Recipe
    
    var body: some View {
        ScrollView () {
            HStack {
                Spacer()
                Image(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 250)
                    .clipped()
                    .cornerRadius(13)
                Spacer()
            }
            .shadow(color: Color("navy").opacity(0.4), radius: 4, x: 0, y: 4)
            VStack (alignment: .leading) {
                Text("\(recipe.name)")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                Text("Ingredients")
                    .font(.title2)
                    .bold()
                Text(" • \(recipe.ingredients.joined(separator: "\n • "))")
                    .font(.subheadline)
                    .background(.white)
                    .foregroundColor(Color("mediumGray"))
                    .padding(.bottom, 10)
                Text("Directions")
                    .font(.title2)
                    .bold()
                Text(recipe.instructions.enumerated().map { " \($0.offset + 1). \($0.element)" }.joined(separator: "\n"))
                    .font(.subheadline)
                    .background(Color.white)
                    .foregroundColor(Color("mediumGray"))
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitle(recipe.name)
    }
}


#Preview {
    RecipeDetailView(recipe: RecipeData.getRandomRecipe())
}
