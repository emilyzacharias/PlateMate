//
//  Recipes.swift
//  PlateMate
//
//  Created by Emily Zacharias on 2/19/24.
//

import Foundation
import CoreData
import SwiftUI

class UserPreferences: ObservableObject {
    @Published var meatRestrict: Bool = false
    @Published var dairyRestrict: Bool = false
    @Published var fishRestrict: Bool = false
    @Published var nutsRestrict: Bool = false
    @Published var eggsRestrict: Bool = false
}

class MenuRecipes: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var ingredients: [String] = []
    @Published var shoppingList: [Ingredient] = []
    
    init() {
        createMenu(excludedAllergens: [])
        updateIngredients()
    }
    
    
    //function to create the menu. it cycles through the entire recipe array and compares them to one random recipe to decide which have the most ingredients in common.
    func createMenu(excludedAllergens: [String]) {
        
        recipes = [RecipeData.getRandomRecipe(excludedAllergens: excludedAllergens)]
        updateIngredients()
        
        var iterations = 0
        
        
        while (recipes.count < 5 || iterations >= 5) {
            iterations += 1
            var mostInCommonRecipe = RecipeData.getRandomRecipe(excludedAllergens: excludedAllergens)
            var numInCommon: Int = 0
            
            for i in 0..<RecipeData.recipes.count {
                let currentRecipe = RecipeData.recipes[i]
                
                // Check if the recipes array already contains a recipe with the same name
                if recipes.contains(where: { $0.name == currentRecipe.name }) {
                    continue
                }
                
                if currentRecipe.allergens.contains(where: { excludedAllergens.contains($0) }) {
                    continue
                }
                
                // Check for common ingredients
                let commonItems = Set(ingredients).intersection(Set(currentRecipe.shoppingIngredients))
                if commonItems.count >= numInCommon && recipes.count < 5 {
                    if (commonItems.count > numInCommon || (commonItems.count == numInCommon && Bool.random() == true)) { // this line makes sure that the same recipes aren't always chosen
                        mostInCommonRecipe = currentRecipe
                        numInCommon = commonItems.count
                    }
                }
            }
            
            recipes.append(mostInCommonRecipe)
            updateIngredients()
            
            //this prevents it from going into an infinite loop if all restrictions are selected
            let maxattempts = 10
            var attempts = 1
            
            if recipes.count < iterations + 1 {
                var newRecipe = RecipeData.getRandomRecipe(excludedAllergens: excludedAllergens)
                while (recipes.contains(where: { $0.name == newRecipe.name }) && attempts < maxattempts) {
                    attempts += 1
                    newRecipe = RecipeData.getRandomRecipe(excludedAllergens: excludedAllergens)
                    if (attempts > maxattempts) {
                        continue
                    }
                }
                recipes.append(newRecipe)
                print("appended random")
            }
            
            if (iterations > 10) { //prevents never ending loops
                break
            }
            updateIngredients()
        }
        
        
    }

    
    //This function updates the shopping list ingredients.
    func updateIngredients() {
        var uniqueIngredients = Set<String>()
        shoppingList = []
        
        for recipe in recipes {
            uniqueIngredients.formUnion(recipe.shoppingIngredients)
        }
        
        ingredients = Array(uniqueIngredients).sorted()
        for ingredient in ingredients {
            shoppingList.append(Ingredient(name: ingredient))
        }
    }
    
    //This function toggles the check next to the ingredient name.
    func toggleisChecked(for name: String) {
            if let index = shoppingList.firstIndex(where: { $0.name == name }) {
                shoppingList[index].isChecked.toggle()
            }
        }
}

struct Ingredient: Identifiable, Hashable {
    var id = UUID()
    var name: String = ""
    var isChecked: Bool = false
}

struct Recipe: Identifiable {
    var id = UUID()
    var name: String = ""
    var ingredients: [String] = []
    var shoppingIngredients: [String] = []
    var instructions: [String] = []
    var isFavorite: Bool = false
    var allergens: [String] = []
    var image: String = "noimage"
}


class RecipeData: ObservableObject {
    static var savedRecipes: [Recipe] = []
    // All of the recipes are stored in this array. In future iterations of this app, it will instead use an API.
    static var recipes: [Recipe] = [
        Recipe(
            name: "Simple Salad",
            ingredients: [
                "1 head Iceberg lettuce",
                "2 Tomatoes (diced)",
                "1 cup Croutons",
                "Your favorite store-bought salad dressing"
            ],
            shoppingIngredients: [
                "Lettuce",
                "Tomatoes",
                "Croutons",
                "Salad dressing"
            ],
            instructions: [
                "Wash and chop the lettuce into bite-sized pieces.",
                "Dice the tomatoes and add them to the lettuce in a large bowl.",
                "Sprinkle croutons over the salad.",
                "Drizzle your favorite store-bought salad dressing over the salad.",
                "Toss the salad gently to combine all the ingredients.",
                "Serve."
            ],
            isFavorite: false,
            allergens: [],
            image: "salad"
        ),
        Recipe(
            name: "Avocado Toast",
            ingredients: ["2 eggs", "2 slices of bread", "Avocado"],
            shoppingIngredients: ["Eggs", "Bread", "Avocado"],
            instructions: ["Toast two slices of bread. For a gluten-free option, use gluten free eggs.", "Cook two eggs as preferred", "Mash avocado evenly onto toast and season with salt and pepper", "Add eggs onto avocado toast."],
            isFavorite: false,
            allergens: ["eggs"],
            image: "avotoast"), 
        Recipe(
            name: "French Toast",
            ingredients: ["2 eggs", "4 bread slices", "1 teaspoon vanilla extract", "1 teaspoon cinnamon", "1 tbsp milk"],
            shoppingIngredients: ["Eggs", "Bread", "Vanilla extract", "Cinnamon", "Milk"],
            instructions: ["Whisk egg, vanilla, and cinnamon in a bowl. Add milk.", "Dip bread into mixture, coating both sides.", "Cook bread on skillet over medium heat until browned on both sides."],
            isFavorite: false,
            allergens: ["eggs", "dairy"],
            image: "frenchtoast"),
        Recipe(
            name: "Steak Hash",
            ingredients: [
                "1 Bag potatoes",
                "3 teaspoons olive oil, divided",
                "3 bell peppers, sliced, seeds and top removed",
                "1 small onion, sliced",
                "4 teaspoons paprika",
                "2 teaspoons garlic salt",
                "cilantro (optional for garnish)",
                "1 flank steak",
                "2 teaspoons season salt"
            ],
            shoppingIngredients: [
                "Potatoes",
                "Olive oil",
                "Bell peppers",
                "Onion",
                "Paprika",
                "Garlic salt",
                "Cilantro",
                "Flank steak",
                "Season salt"
            ],
            instructions: [
                "Sprinkle season salt on both sides of the flank steak and grill on a pan over medium heat for 6-8 minutes per side. Rest for 10 minutes, then chop.",
                "Heat 2 teaspoons of olive oil in a large saute pan over medium heat. Cook bell peppers and onion until tender (about 3 minutes).",
                "Add the bag of potatoes and the remaining olive oil to the pan. Cook until hot and golden on the outside.",
                "Once the potatoes are cooked, add the chopped steak. Toss and allow to cook for an additional 2 minutes.",
                "Serve with fresh cilantro for a burst of freshness."
            ],
            isFavorite: false,
            allergens: ["meat"],
            image: "steak"),
        Recipe(
            name: "Black Bean Tacos with Avocado",
            ingredients: [
                "Olive oil",
                "1 clove garlic",
                "1 cup black beans (with liquid)",
                "1/2 teaspoon ground cumin",
                "1/2 teaspoon ground coriander",
                "1/4 teaspoon chili powder",
                "Salt (to taste)",
                "4 corn tortillas",
                "1 ripe avocado",
                "1 to 2 ounces goat cheese",
                "Minced red onion",
                "Lime wedges",
                "Hot Sauce",
                "Cilantro"
            ],
            shoppingIngredients: [
                "Olive oil",
                "Garlic",
                "Black beans",
                "Cumin",
                "Coriander",
                "Chili powder",
                "Corn tortillas",
                "Avocado",
                "Goat cheese",
                "Onion",
                "Lime",
                "Hot Sauce",
                "Cilantro"
            ],
            instructions: [
                "In a small pot or skillet over medium-low heat, add olive oil and 1 clove minced garlic. Cook for 1 to 2 minutes until the garlic begins to brown.",
                "Place black beans and their liquid in a pan. Add ground cumin, ground coriander, garlic powder, and chili powder. Heat over medium-low heat until the majority of the liquid is absorbed. Taste and add salt as needed.",
                "Heat the corn tortillas until soft and cut the avocado into slices.",
                "Assemble the tacos with ¼ of the spiced black bean mixture, a few slices of avocado, a sprinkle of goat cheese, and desired toppings.",
                "Enjoy the easy and fresh black bean tacos topped with cilantro, minced red onion, lime wedges, and hot sauce."
            ],
            isFavorite: false,
            allergens: ["dairy"],
            image: "tacos"),
        Recipe(
            name: "Cheesy Ravioli Bake",
            ingredients: [
                "1 lb cheese ravioli",
                "24 oz jar of marinara sauce",
                "1 cup mozzarella cheese, shredded",
                "1/4 cup flat-leaf parsley",
                "4 oz fresh mozzarella, sliced"
            ],
            shoppingIngredients: [
                "Cheese ravioli",
                "Marinara sauce",
                "Mozzarella cheese",
                "Parsley",
                "Fresh mozzarella"
            ],
            instructions: [
                "Preheat the oven to 350 degrees F. Coat a 9×9 square baking dish with cooking spray and set aside.",
                "Boil the cheese ravioli in water for 3 minutes. Drain and rinse.",
                "In a medium bowl, combine the cooked ravioli, marinara sauce, shredded mozzarella cheese, and flat-leaf parsley. Gently stir until the mixture is well combined.",
                "Pour the mixture into the prepared baking dish. Top with slices of fresh mozzarella and additional parsley if desired.",
                "Bake uncovered in the preheated oven for 30 minutes or until the pasta is heated through, and the cheeses are melted.",
                "Serve warm!"
            ],
            isFavorite: false,
            allergens: ["dairy"],
            image: "ravioli"),
        Recipe(
            name: "Bacon Asparagus Pasta",
            ingredients: [
                "1/2 lb. uncooked pasta",
                "1/2 lb. bacon, diced",
                "1/2 lb. asparagus",
                "1/2 cup dry white wine",
                "1/2 cup Grated or flaked Parmesan cheese"
            ],
            shoppingIngredients: [
                "Pasta",
                "Bacon",
                "Asparagus",
                "White wine",
                "Parmesan"
            ],
            instructions: [
                "Cook the pasta in a large pot of generously-salted water al dente according to package instructions.",
                "Meanwhile, add diced bacon to a medium sauté pan. Cook over medium-high heat, stirring occasionally, until crispy. Remove the bacon with a slotted spoon and set aside.",
                "Add asparagus to the pan and sauté in the bacon grease for about 5-6 minutes, stirring occasionally, until cooked. Remove asparagus with a slotted spoon and set aside with the bacon.",
                "Slowly add the white wine to the pan, scraping the bottom of the pan with a spoon to deglaze and pick up the brown bits. Continue cooking for 5 minutes, or until the wine has reduced by about half.",
                "When the pasta is cooked, drain it. Then add the pasta, asparagus, bacon, and 1/4 cup Parmesan cheese to the sauté pan, and toss until combined.",
                "Sprinkle pasta with the remaining Parmesan cheese and serve immediately.",
                "If the pasta seems too dry, add in 1/4 cup of the pasta water after adding in the asparagus and bacon, and toss to combine."
            ],
            isFavorite: false,
            allergens: ["dairy"],
            image: "asparpasta"
        ),
        Recipe(
            name: "Pesto Chicken Stuffed Peppers",
            ingredients: [
                "6 Bell peppers",
                "2 Chicken breasts",
                "1 1/2 cups Mozzarella cheese",
                "1 cup cooked quinoa",
                "Jar pesto"
            ],
            shoppingIngredients: [
                "Bell peppers",
                "Chicken",
                "Mozzarella cheese",
                "Quinoa",
                "Pesto"
            ],
            instructions: [
                "Turn on the broiler to high. Place bell peppers under the broiler and broil for 5 minutes on each side until the skin blisters and begins to turn black.",
                "Remove peppers from the oven, set aside. Preheat the oven to 350 degrees.",
                "In a medium-sized mixing bowl, combine the shredded chicken with 1 cup shredded cheese, pesto, and quinoa. Toss to coat.",
                "Once peppers are cool enough to handle, slice in half and remove membranes and seeds. Add a heaping 1/4 cup of the chicken mixture to each pepper and top with cheese.",
                "Bake for 10 minutes. Serve immediately."
            ],
            isFavorite: false,
            allergens: ["dairy", "meat"],
            image: "pepper"
        ),
        Recipe(
            name: "Chicken Chili",
            ingredients: [
                "6 cups Chicken stock",
                "3 to 4 cups Cooked shredded chicken",
                "2 (15-ounce) cans Beans of your choice (rinsed and drained, I used Great Northern beans)",
                "2 cups (16 ounces) Salsa (store-bought or homemade)",
                "2 teaspoons Ground cumin"
            ],
            shoppingIngredients: [
                "Chicken stock",
                "Chicken",
                "Beans",
                "Salsa verde",
                "Cumin"
            ],
            instructions: [
                "Combine ingredients. Stir together chicken stock, shredded chicken, beans, salsa, and cumin in a large stockpot.",
                "Bring to a simmer. Cook on high heat until the soup reaches a simmer. Reduce heat to medium-low and continue simmering for 5 minutes.",
                "Serve. Serve immediately, garnished with lots of your favorite toppings."
            ],
            isFavorite: false,
            allergens: ["meat"],
            image: "chili"
        ),
        Recipe(
            name: "Spaghetti Carbonara",
            ingredients: [
                "8 ounces Spaghetti",
                "2 large Eggs",
                "½ cup Freshly grated Parmesan",
                "4 slices Bacon (diced)",
                "4 cloves Garlic (minced)",
                "Kosher salt and freshly ground black pepper, to taste",
                "2 tablespoons Chopped fresh parsley leaves"
            ],
            shoppingIngredients: [
                "Spaghetti",
                "Eggs",
                "Parmesan",
                "Bacon",
                "Garlic",
                "Parsley leaves"
            ],
            instructions: [
                "Cook the spaghetti in a large pot of boiling salted water according to package instructions. Reserve 1/2 cup water and drain well.",
                "Whisk together eggs and Parmesan in a small bowl; set aside.",
                "Heat a large cast-iron skillet over medium-high heat. Add diced bacon and cook until brown and crispy, about 6-8 minutes. Reserve excess fat.",
                "Stir in minced garlic until fragrant, about 1 minute. Reduce heat to low.",
                "Working quickly, stir in pasta and egg mixture, gently toss to combine. Season with salt and pepper to taste. Add reserved pasta water, one tablespoon at a time, until the desired consistency is reached.",
                "Serve immediately, garnished with chopped fresh parsley leaves if desired."
            ],
            isFavorite: false,
            allergens: ["dairy", "eggs", "meat"],
            image: "carbonara"
        ),
        Recipe(
            name: "Black Bean Soup",
            ingredients: [
                "3 (15 oz) cans Black beans (with liquid)",
                "1 lb. (about 2.5 cups) Good-quality salsa (homemade or store-bought, e.g., Herdez brand)",
                "1/2 cup Chopped fresh cilantro (loosely packed, plus extra for garnish)",
                "2 tsp. Ground cumin",
                "1 Clove garlic (minced)"
            ],
            shoppingIngredients: [
                "Black beans",
                "Salsa",
                "Cilantro",
                "Ground cumin",
                "Clove garlic"
            ],
            instructions: [
                "Stir all ingredients together in a medium saucepan.",
                "Heat over medium-high heat until simmering.",
                "Reduce heat to medium-low, cover, and simmer for at least 10 minutes, stirring occasionally.",
                "Serve the soup warm, topped with additional fresh cilantro as a garnish."
            ],
            isFavorite: false,
            allergens: [],
            image: "beansoup"
        ),
        Recipe(
            name: "Cacio e Pepe",
            ingredients: [
                "Salt, to taste",
                "½ lb Spaghetti",
                "2 tablespoons Olive oil",
                "2 tablespoons Unsalted butter",
                "2 teaspoons Coarsely ground black pepper",
                "4 oz Grated Parmesan cheese"
            ],
            shoppingIngredients: [
                "Spaghetti",
                "Olive oil",
                "Butter",
                "Parmesan cheese"
            ],
            instructions: [
                "Bring a large pot of salted water to a boil. Cook the pasta for 1 minute less than the package instructs, until al dente. Save 1 cup (240 ml) pasta water, then drain.",
                "Heat a large sauté pan over medium heat. Add the olive oil, butter, and pepper, and stir to combine.",
                "Stir in the reserved pasta water.",
                "Toss in the cooked pasta. Reduce the heat to low.",
                "Add the Parmesan and toss until the cheese is melted and the pasta is well-coated.",
                "Season with salt, if desired.",
                "Enjoy!"
            ],
            isFavorite: false,
            allergens: ["dairy"],
            image: "cacio"
        ),
        Recipe(
            name: "Cheeseburgers",
            ingredients: [
                "2 lb Ground beef",
                "1 tsp Cracked pepper",
                "1 tsp Kosher salt",
                "2 Tbs Dijon mustard",
                "1.5 Tbs Worcestershire sauce",
                "Hamburger buns",
                "Lettuce",
                "Tomato (sliced)",
                "Cheese",
                "Onions (sliced)"
            ],
            shoppingIngredients: [
                "Ground beef",
                "Dijon mustard",
                "Worcestershire sauce",
                "Hamburger buns",
                "Lettuce",
                "Tomato",
                "Cheese",
                "Onion"
            ],
            instructions: [
                "Combine ground beef, cracked pepper, salt, mustard, and Worcestershire sauce.",
                "Gently form the mixture into 8 patties.",
                "Heat the grill or skillet to high.",
                "Cook patties for 2-3 minutes per side. If you make them thicker, you’ll need to cook them longer.",
                "Serve on grilled hamburger buns with lettuce, tomato, cheese, and onions. Add pickles if desired."
            ],
            isFavorite: false,
            allergens: ["dairy", "meat"],
            image: "burger"
        ),
        Recipe(
            name: "Pesto Pasta Salad",
            ingredients: [
                "1 lb bowtie pasta",
                "1 jar pesto",
                "3 handfuls arugla",
                "1 cup cherry tomatoes"
            ],
            shoppingIngredients: [
                "Tomato",
                "Pesto",
                "Arugala",
                "Pasta"
            ],
            instructions: [
                "Prepare pasta according to package directions.",
                "Toss pesto, argula, tomatoes, and pasta in a large bowl."
            ],
            isFavorite: false,
            allergens: [],
            image: "pestosalad"
        ),
        Recipe(
            name: "Pineapple and Barbecue Pizza",
            ingredients: [
                "1 Store-bought pizza crust",
                "1/2 cup Barbecue sauce",
                "1 cup Shredded mozzarella cheese",
                "1/2 cup Canned pineapple chunks",
                "1/4 Red onion (sliced)"
            ],
            shoppingIngredients: [
                "Pizza crust",
                "Barbecue sauce",
                "Mozzarella cheese",
                "Canned pineapple chunks",
                "Red onion"
            ],
            instructions: [
                "Preheat your oven according to the pizza crust instructions.",
                "Spread 1/2 cup barbecue sauce on the pizza crust as the base.",
                "Sprinkle 1 cup shredded mozzarella cheese over the sauce.",
                "Add 1/2 cup canned pineapple chunks and 1/4 red onion (sliced) as toppings.",
                "Bake the pizza in the preheated oven until the crust is golden and the cheese is melted.",
                "Slice and enjoy your simple Pineapple and Barbecue Pizza!"
            ],
            isFavorite: false,
            allergens: ["dairy"],
            image: "pineapplepizza"
        ),
        Recipe(
            name: "Coconut Fish Curry",
            ingredients: [
                "1 lb White fish fillets (such as cod or tilapia)",
                "1 can (14 oz) Coconut milk",
                "2 tablespoons Red curry paste",
                "1 tablespoon Fish sauce",
                "1 tablespoon Brown sugar",
                "1 Red bell pepper (sliced)",
                "1 Zucchini (sliced)",
                "1 Lime (cut into wedges)",
                "Fresh cilantro (for garnish)"
            ],
            shoppingIngredients: [
                "White fish fillets",
                "Coconut milk",
                "Red curry paste",
                "Fish sauce",
                "Brown sugar",
                "Red bell pepper",
                "Zucchini",
                "Lime",
                "Fresh cilantro"
            ],
            instructions: [
                "Cut the white fish fillets into bite-sized pieces.",
                "In a large pan, combine coconut milk, red curry paste, fish sauce, and brown sugar. Bring to a simmer over medium heat.",
                "Add the sliced red bell pepper and zucchini to the pan. Cook until the vegetables are tender.",
                "Gently add the fish pieces to the simmering curry. Cook until the fish is opaque and cooked through.",
                "Serve the coconut fish curry over rice, garnished with lime wedges and fresh cilantro.",
                "Enjoy your delicious Coconut Fish Curry!"
            ],
            isFavorite: false,
            allergens: ["fish"],
            image: "fishcurry"
        ),
        Recipe(
            name: "Shrimp Ramen",
            ingredients: [
                "1 lb Shrimp",
                "2 Soft-boiled eggs",
                "2 Packs store-bought ramen noodles",
                "4 cups Chicken or vegetable broth",
                "2 Green onions (sliced)",
                "1 Carrot (julienned)",
                "1 cup Spinach leaves",
                "Soy sauce"
            ],
            shoppingIngredients: [
                "Shrimp",
                "Eggs",
                "Ramen noodles",
                "Chicken broth",
                "Green onions",
                "Carrot",
                "Spinach leaves",
                "Soy sauce"
            ],
            instructions: [
                "Cook store-bought ramen noodles according to package instructions. Drain and set aside.",
                "Simmer shrimp in chicken or vegetable broth until pink and opaque.", 
                "Divide cooked ramen noodles into bowls. Pour hot shrimp broth over the noodles.",
                "Top with julienned carrots, spinach leaves, and sliced green onions.",
                "Season with soy sauce to taste. Add optional sesame oil for extra flavor.",
                "Place a soft-boiled egg in each bowl.",
                "Serve your Easy Shrimp Ramen with Soft-Boiled Eggs hot and enjoy!"
            ],
            isFavorite: false,
            allergens: ["fish", "eggs"],
            image: "shrimpramen"
        ),
        Recipe(
            name: "Chicken Pepper Curry",
            ingredients: [
                "1 lb Chicken breasts (cut into bite-sized pieces)",
                "1 Onion (chopped)",
                "1 Bell pepper (sliced)",
                "1 can (14 oz) Diced tomatoes",
                "2 tablespoons Vegetable oil",
                "1 teaspoon Ground black pepper",
                "1 teaspoon Turmeric powder",
                "1 teaspoon Curry powder",
                "Salt (to taste)",
                "Fresh cilantro (for garnish, optional)",
                "Cooked rice"
            ],
            shoppingIngredients: [
                "Chicken",
                "Onion",
                "Bell peppers",
                "Tomatoes",
                "Vegetable oil",
                "Turmeric powder",
                "Curry powder",
                "Cilantro"
            ],
            instructions: [
                "In a pan, heat vegetable oil. Sauté chopped onions until golden brown.",
                "Add chicken pieces and cook until no longer pink.",
                "Stir in sliced bell pepper and canned diced tomatoes. Cook until vegetables are tender.",
                "Season with ground black pepper, turmeric powder, curry powder, and salt. Mix well.",
                "Simmer until the chicken is cooked through and the curry thickens.",
                "Garnish with fresh cilantro if desired.",
                "Serve your curry over rice."
            ],
            isFavorite: false,
            allergens: ["meat"],
            image: "curry"
        ),
        Recipe(
            name: "Alfredo Linguine with Broccoli and Ham",
            ingredients: [
                "1 jar Alfredo sauce",
                "1 lb Linguine",
                "2 cups Broccoli florets",
                "1 cup Cooked ham (diced)"
            ],
            shoppingIngredients: [
                "Alfredo sauce",
                "Linguine",
                "Broccoli",
                "Ham"
            ],
            instructions: [
                "Cook linguine according to package instructions. Drain and set aside.",
                "In a separate pot, steam or boil broccoli until tender. Drain and set aside.",
                "In a large pan, heat Alfredo sauce over medium heat.",
                "Add the cooked linguine, steamed broccoli, and diced ham to the Alfredo sauce. Stir to coat evenly.",
                "Continue heating until the mixture is thoroughly warmed.",
                "Serve."
            ],
            isFavorite: false,
            allergens: ["dairy"],
            image: "alfredo"
        ),
        Recipe(
            name: "Paneer Tikka Masala",
            ingredients: [
                "1 lb Paneer (cubed)",
                "1 cup Yogurt",
                "1 Onion (chopped)",
                "1 can (14 oz) Diced tomatoes",
                "2 tablespoons Vegetable oil",
                "2 teaspoons Ginger-garlic paste",
                "1 teaspoon Garam masala",
                "1 teaspoon Cumin powder",
                "1 teaspoon Coriander powder",
                "1/2 teaspoon Turmeric powder",
                "1/2 teaspoon Red chili powder (adjust to taste)",
                "Salt (to taste)",
                "Fresh cilantro (for garnish, optional)"
            ],
            shoppingIngredients: [
                "Paneer",
                "Yogurt",
                "Onion",
                "Tomatoes",
                "Vegetable oil",
                "Ginger-garlic paste",
                "Garam masala",
                "Cumin powder",
                "Coriander",
                "Turmeric powder",
                "Red chili powder",
                "Rice"
            ],
            instructions: [
                "In a bowl, marinate cubed paneer with yogurt, garam masala, cumin powder, coriander powder, turmeric powder, red chili powder, and salt. Set aside for at least 30 minutes.",
                "In a pan, heat vegetable oil. Sauté chopped onions until golden brown.",
                "Add ginger-garlic paste and cook until fragrant.",
                "Stir in diced tomatoes and cook until the mixture thickens.",
                "Add marinated paneer and cook until the paneer is heated through.",
                "Garnish with fresh cilantro if desired.",
                "Serve your Simple Paneer Tikka Masala over rice."
            ],
            isFavorite: false,
            allergens: ["dairy"],
            image: "paneer"
        )
    ]
    
    
    //Function that returns a random recipe list from the recipe list.
    static func getRandomRecipes(count: Int = 5) -> [Recipe] {
        let shuffledRecipes = recipes.shuffled()
        let selectedRecipes = Array(shuffledRecipes.prefix(count))
        return selectedRecipes
    }
    
    //Function that toggles if a recipe is favorited or not.
    static func toggleFav(for recipeName: String) {
        if let index = recipes.firstIndex(where: { $0.name == recipeName }) {
            recipes[index].isFavorite.toggle()

            if recipes[index].isFavorite {
                // If the recipe is marked as a favorite, add it to the savedRecipes array
                savedRecipes.append(recipes[index])
            } else {
                // If the recipe is not a favorite anymore, remove it from the savedRecipes array
                savedRecipes.removeAll { $0.name == recipeName }
            }

        }
    }

    //Function that adds a recipe to the favorites array.
    static func addToFavorites(recipe: Recipe) {
        savedRecipes.append(recipe)
    }
    
    //Function that saves a recipe to the favorites array.
    static func isFavorite(for recipeName: String) -> Bool {
        return savedRecipes.contains { $0.name == recipeName }
    }
    
    //Function that deletes a recipe from favorites.
    static func deleteFavorite(for recipeName: String) {
        savedRecipes.removeAll { $0.name == recipeName }
    }
    
    /*
    static func isFavorite(for recipeName: String) -> Bool {
        return recipes.first { $0.name == recipeName }?.isFavorite ?? false
    } */
    
    //Function that returns one random recipe.
    static func getRandomRecipe(count: Int = 1, excludedAllergens: [String] = []) -> Recipe {
        let filteredRecipes = recipes.filter { recipe in
            !recipe.allergens.contains { excludedAllergens.contains($0) }
        }
        
        guard !filteredRecipes.isEmpty else {
            
            return RecipeData.recipes[0]
        }
        
        let shuffledRecipes = filteredRecipes.shuffled()
        let selectedRecipes = Array(shuffledRecipes.prefix(count))
        
        return selectedRecipes[0]
    }
    
}
