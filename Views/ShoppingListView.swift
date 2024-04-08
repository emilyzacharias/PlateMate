//
//  ShoppingListView.swift
//  PlateMate
//
//  Created by Emily Zacharias on 2/6/24.
//

import SwiftUI

//This is where the user can see the shopping list created from the generated menu.
struct ShoppingListView: View {
    @ObservedObject var menuRecipes: MenuRecipes
    
    var body: some View {
        ZStack {
            Color("background")
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text("Shopping list")
                        .font(.title)
                        .bold()
                        .padding(.leading, 10)
                    
                    let shoppingListText = menuRecipes.ingredients.joined(separator: "\n")
                    Spacer()
                    ShareLink(item: shoppingListText)
                        .foregroundColor(.black)
                }
                .padding(.vertical, 10)
                VStack {
                    
                    List(menuRecipes.shoppingList, id: \.self) { ingredient in
                        HStack {
                            
                            Image(systemName: ingredient.isChecked ? "checkmark.circle.fill" : "circle")
                                
                            
                            Text(ingredient.name)
                        }
                        .onTapGesture {
                            menuRecipes.toggleisChecked(for: ingredient.name)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    //.listStyle(PlainListStyle())
                    
                }
                .padding(.bottom, 40)
                
            }
            .padding(.vertical, 50)
            .padding(.horizontal, 20)
            .ignoresSafeArea()
        }
        .padding(.bottom, 20)
        .ignoresSafeArea()
    }
    
}
