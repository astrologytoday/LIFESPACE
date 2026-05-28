//
//  IngredientIndex.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-13.
//

import Foundation

enum IngredientCategory: String, CaseIterable, Codable {
    case produce = "Produce"
    case grains = "Grains"
    case meatFish = "Meat / Fish"
    case dairy = "Dairy"
    case herbsSpices = "Herbs / Spices"
    case saucesBroth = "Sauces / Broth"
    case other = "Other"
}

// MARK: - Subcategories used to group items *within* a section
enum IngredientSubcategory: String, CaseIterable, Codable {
    // Produce
    case berry, fruit, vegetable, produceOther

    // Grains
    case bread, tortilla, flour, pasta, noodle, rice, oats, cereal, grainOther

    // Meat / Fish
    case poultry, redMeat, fish, deli, meatOther

    // Dairy
    case eggs, milk, yogurt, cheese, butter, dairyOther

    // Herbs / Spices / Sauces / Broth / Other
    case herb, spice, sweetener, herbsSpicesOther
    
    case sauce, broth, saucesBrothOther
    
    case other
}

struct IngredientIndex {

    static let explicit: [String: IngredientCategory] = [
        // Dairy
        "Milk": .dairy,
        "Cheese": .dairy,
        "Greek Yogurt": .dairy,
        "Parmesan": .dairy,
        "Feta": .dairy,
        "Butter": .dairy,
        "Almond Milk": .dairy,
        "Cheddar Cheese": .dairy,
        "Cottage Cheese": .dairy,
        "Cream Cheese": .dairy,
        "Feta Cheese": .dairy,
        "Goat Cheese": .dairy,
        "Heavy Cream": .dairy,
        "Kefir": .dairy,
        "Kefir Milk": .dairy,
        "Kefir Yogurt": .dairy,
        "Mozzarella": .dairy,
        "Parmesan Cheese": .dairy,
        "Plain Greek Yogurt": .dairy,
        "Plain Yogurt": .dairy,
        "Eggs": .dairy,
        "Provolone Cheese": .dairy,
        "Stilton Cheese": .dairy,
        "Swiss Cheese": .dairy,
        "Sour Cream": .dairy,
        "Duck Eggs": .dairy,

        // Meat & Fish
        "Chicken": .meatFish,
        "Beef": .meatFish,
        "Turkey": .meatFish,
        "Salmon": .meatFish,
        "Fish": .meatFish,
        "Bacon": .meatFish,
        "Chicken Breasts": .meatFish,
        "Chicken Thighs": .meatFish,
        "Ground Beef": .meatFish,
        "Ground Chicken": .meatFish,
        "Ground Lamb": .meatFish,
        "Ham": .meatFish,
        "Lamb": .meatFish,
        "Liver": .meatFish,
        "Mackerel": .meatFish,
        "Pancetta": .meatFish,
        "Pork": .meatFish,
        "Prosciutto": .meatFish,
        "Sardines": .meatFish,
        "Shrimp": .meatFish,
        "Smoked Salmon": .meatFish,
        "Steak": .meatFish,
        "Turkey Legs": .meatFish,
        "Chicken Breast": .meatFish,
        "Tilapia": .meatFish,

        // Grains
        "Bread": .grains,
        "Bread Crumbs": .grains,
        "Burger Buns": .grains,
        "English Muffins": .grains,
        "Flour": .grains,
        "Oats": .grains,
        "Pasta": .grains,
        "Pie Crust": .grains,
        "Rice": .grains,
        "Basmati Rice": .grains,
        "Arborio Rice": .grains,
        "Jasmine Rice": .grains,
        "Brown Rice": .grains,
        "Sprouted Bread": .grains,
        "Whole Grain Bagels": .grains,
        "Whole Grain Bread": .grains,
        "Whole Grain Flour": .grains,
        "Whole Grain Pizza Dough": .grains,
        "Whole Grain Tortillas": .grains,
        "Linguine": .grains,
        "Gnocchi": .grains,
        "Fettuccine": .grains,
        "Graham Crackers": .grains,
        "Macaroni": .grains,
        "Noodles": .grains,
        "Penne": .grains,
        "Pizza Dough": .grains,
        "Rice Paper": .grains,
        "Rice Vermicelli": .grains,
        "Rigatoni": .grains,

        // Produce (Fruits & Vegetables)
        "Arugula": .produce,
        "Apples": .produce,
        "Asparagus": .produce,
        "Avocados": .produce,
        "Bananas": .produce,
        "Beets": .produce,
        "Sunchokes": .produce,
        "Bell Peppers": .produce,
        "Blackberries": .produce,
        "Blueberries": .produce,
        "Raspberries": .produce,
        "Broccoli": .produce,
        "Brussels Sprouts": .produce,
        "Cabbage": .produce,
        "Red Cabbage": .produce,
        "Kiwi": .produce,
        "Capers": .produce,
        "Carrots": .produce,
        "Cauliflower": .produce,
        "Cherries": .produce,
        "Celery": .produce,
        "Cherry Tomatoes": .produce,
        "Chives": .produce,
        "Cucumber": .produce,
        "Cucumbers": .produce,
        "Dried Cranberries": .produce,
        "Fava Beans": .produce,
        "Fennel": .produce,
        "Frozen Mango": .produce,
        "Garlic": .produce,
        "Ginger": .produce,
        "Grapes": .produce,
        "Green Onions": .produce,
        "Jalapeño Peppers": .produce,
        "Kale": .produce,
        "Leek": .produce,
        "Lemons": .produce,
        "Lentils": .produce,
        "Lettuce": .produce,
        "Mango": .produce,
        "Mixed Berries": .produce,
        "Mixed Greens": .produce,
        "Mushrooms": .produce,
        "Oranges": .produce,
        "Okra": .produce,
        "Olives": .produce,
        "Peanuts": .produce,
        "Peas": .produce,
        "Pickles": .produce,
        "Pineapple": .produce,
        "Plum Tomatoes": .produce,
        "Pomegranate": .produce,
        "Pomegranate Seeds": .produce,
        "Portobello Mushrooms": .produce,
        "Potatoes": .produce,
        "Pumpkin Seeds": .produce,
        "Red Bell Pepper": .produce,
        "Red Chili Peppers": .produce,
        "Red Chili Powder": .produce,
        "Red Onions": .produce,
        "Salad Greens": .produce,
        "Scallions": .produce,
        "Shallots": .produce,
        "Snap Peas": .produce,
        "Spinach": .produce,
        "Squash": .produce,
        "Strawberries": .produce,
        "Sunflower Seeds": .produce,
        "Sweet Potatoes": .produce,
        "Tomatoes": .produce,
        "Zucchini": .produce,
        "Corn": .produce,
        "Seaweed": .produce,

        // Herbs & Spices
        "Basil": .herbsSpices,
        "Bay Leaves": .herbsSpices,
        "Baking Powder": .herbsSpices,
        "Cardamom": .herbsSpices,
        "Cayenne Pepper": .herbsSpices,
        "Chervil": .herbsSpices,
        "Chilli Flakes": .herbsSpices,
        "Chili Flakes": .herbsSpices,
        "Chili Powder": .herbsSpices,
        "Cilantro": .herbsSpices,
        "Cinnamon": .herbsSpices,
        "Coriander": .herbsSpices,
        "Curry Powder": .herbsSpices,
        "Cumin": .herbsSpices,
        "Dill": .herbsSpices,
        "Dried Thyme": .herbsSpices,
        "Garam Masala": .herbsSpices,
        "Garlic Powder": .herbsSpices,
        "Italian Herbs": .herbsSpices,
        "Mustard": .herbsSpices,
        "Nutmeg": .herbsSpices,
        "Oregano": .herbsSpices,
        "Paprika": .herbsSpices,
        "Parsley": .herbsSpices,
        "Rosemary": .herbsSpices,
        "Sage": .herbsSpices,
        "Tarragon": .herbsSpices,
        "Thyme": .herbsSpices,
        "Turmeric": .herbsSpices,
        "Cajun Seasoning": .herbsSpices,
        "Onion Powder": .herbsSpices,
        "Vanilla Extract": .herbsSpices,
        
        // Sauces & Broth
        "Alfredo Sauce": .saucesBroth,
        "Barbecue Sauce": .saucesBroth,
        "Beef Broth": .saucesBroth,
        "Chicken Broth": .saucesBroth,
        "Chili Paste": .saucesBroth,
        "Dijon Mustard": .saucesBroth,
        "Fish Sauce": .saucesBroth,
        "Honey": .saucesBroth,
        "Hot Sauce": .saucesBroth,
        "Maple Syrup": .saucesBroth,
        "Vegan Mayonnaise": .saucesBroth,
        "Miso Paste": .saucesBroth,
        "Peanut Butter": .saucesBroth,
        "Pesto": .saucesBroth,
        "Tahini": .saucesBroth,
        "Tzatziki": .saucesBroth,
        
    ]

    // MARK: - Subcategory ordering for each main section
    static let subcategoryOrderByCategory: [IngredientCategory: [IngredientSubcategory]] = [
        .produce:      [.berry, .fruit, .vegetable, .produceOther],
        .grains:       [.bread, .tortilla, .flour, .pasta, .noodle, .rice, .oats, .cereal, .grainOther],
        .meatFish:     [.poultry, .redMeat, .fish, .deli, .meatOther],
        .dairy:        [.eggs, .milk, .yogurt, .cheese, .butter, .dairyOther],
        .herbsSpices:  [.herb, .spice, .sweetener, .herbsSpicesOther],
        .saucesBroth:  [.sauce, .broth, .saucesBrothOther],
    ]

    // MARK: - Known subcategory overrides (extend freely)
    static let explicitSubcategories: [String: IngredientSubcategory] = [
            // Produce – fruit / berries
            "Blueberries": .berry, "Blackberries": .berry, "Raspberries": .berry,
            "Strawberries": .berry, "Grapes": .berry,
            "Apple": .fruit, "Apples": .fruit, "Banana": .fruit, "Bananas": .fruit,
            "Kiwi": .fruit, "Pineapple": .fruit, "Mixed Berries": .fruit, "Lemons": .fruit,
            "Mango": .fruit, "Avocado": .fruit, "Avocados": .fruit,
            "Pomegranate": .fruit, "Pomegranate Seeds": .fruit,

            // Produce – vegetables / herbs / other
            "Cherry Tomatoes": .vegetable, "Tomatoes": .vegetable,
            "Broccoli": .vegetable, "Spinach": .vegetable, "Kale": .vegetable,
            "Carrots": .vegetable, "Bell Peppers": .vegetable, "Red Bell Pepper": .vegetable,
            "Cauliflower": .vegetable, "Zucchini": .vegetable, "Onion": .vegetable,
            "Red Onions": .vegetable, "Leek": .vegetable, "Asparagus": .vegetable,
            "Cabbage": .vegetable, "Red Cabbage": .vegetable, "Okra": .vegetable, "Peas": .vegetable,
            "Mushrooms": .vegetable, "Portobello Mushrooms": .vegetable,
            "Sunchokes": .vegetable, "Beets": .vegetable, "Celery": .vegetable,
            "Lettuce": .vegetable, "Mixed Greens": .vegetable, "Salad Greens": .vegetable,
            "Garlic": .vegetable, "Ginger": .vegetable, "Jalapeño Peppers": .vegetable,
            "Corn": .vegetable, "Cucumber": .vegetable, "Cucumbers": .vegetable,

            "Scallions": .herb, "Chives": .herb, "Parsley": .herb, "Cilantro": .herb, "Basil": .herb, "Dill": .herb,
            "Olives": .produceOther, "Capers": .produceOther, "Seaweed": .produceOther, "Frozen Mango": .produceOther,

            // Grains
            "Bread": .bread, "Burger Buns": .bread, "English Muffins": .bread,
            "Sprouted Bread": .bread, "Whole Grain Bread": .bread,
            "Whole Grain Bagels": .bread, "Pizza Dough": .bread, "Whole Grain Pizza Dough": .bread,

            "Whole Grain Tortillas": .tortilla, "Tortillas": .tortilla,
            "Flour": .flour, "Whole Grain Flour": .flour,

            "Spaghetti": .pasta, "Penne": .pasta, "Rigatoni": .pasta, "Macaroni": .pasta,
            "Linguine": .pasta, "Fettuccine": .pasta, "Gnocchi": .pasta,
            "Noodles": .noodle, "Rice Paper": .noodle, "Rice Vermicelli": .noodle,

            "Rice": .rice, "Basmati Rice": .rice, "Jasmine Rice": .rice,
            "Arborio Rice": .rice, "Brown Rice": .rice,
            "Oats": .oats,

            // Meat / fish
            "Chicken": .poultry, "Chicken Breast": .poultry,
            "Chicken Breasts": .poultry, "Chicken Thighs": .poultry,
            "Turkey": .poultry, "Turkey Legs": .poultry,

            "Beef": .redMeat, "Ground Beef": .redMeat, "Steak": .redMeat,
            "Lamb": .redMeat, "Ground Lamb": .redMeat, "Pork": .redMeat,
            "Bacon": .redMeat, "Ham": .redMeat,

            "Salmon": .fish, "Smoked Salmon": .fish, "Mackerel": .fish,
            "Sardines": .fish, "Tilapia": .fish, "Fish": .fish, "Shrimp": .fish,
            "Prosciutto": .deli, "Pancetta": .deli,
            "Duck Eggs": .eggs, "Eggs": .eggs,

            // Dairy
            "Milk": .milk, "Almond Milk": .milk, "Kefir Milk": .milk, "Heavy Cream": .milk,
            "Kefir Yogurt": .yogurt, "Sour Cream": .yogurt,
            "Yogurt": .yogurt, "Greek Yogurt": .yogurt,
            "Plain Greek Yogurt": .yogurt, "Plain Yogurt": .yogurt, "Cream Cheese": .yogurt,

            "Cheese": .cheese, "Cheddar Cheese": .cheese, "Swiss Cheese": .cheese, "Feta": .cheese,
            "Feta Cheese": .cheese, "Parmesan": .cheese, "Parmesan Cheese": .cheese,
            "Goat Cheese": .cheese, "Mozzarella": .cheese,
            "Provolone Cheese": .cheese, "Stilton Cheese": .cheese, "Blue Cheese": .cheese,

            // Herbs & Spices (keep only once each)
            "Oregano": .herb, "Thyme": .herb, "Rosemary": .herb, "Sage": .herb, "Italian Herbs": .herb,
            "Cumin": .spice, "Paprika": .spice, "Cinnamon": .spice, "Turmeric": .spice,
            "Garam Masala": .spice, "Curry Powder": .spice, "Coriander": .spice,
            "Chili Powder": .spice, "Chili Flakes": .spice, "Chilli Flakes": .spice, "Onion Powder": .spice,

            // Sweeteners / sauces / broth
            "Baking Powder": .sweetener, "Vanilla Extract": .sweetener,
            "Honey": .sweetener, "Maple Syrup": .sweetener,

            "Pesto": .sauce, "Alfredo Sauce": .sauce, "Barbecue Sauce": .sauce, "Hot Sauce": .sauce,
            "Miso Paste": .sauce, "Fish Sauce": .sauce, "Tahini": .sauce, "Tzatziki": .sauce,
            "Dijon Mustard": .sauce, "Mustard": .sauce, "Vegan Mayonnaise": .sauce, "Chili Paste": .sauce,
            "Peanut Butter": .sauce,

            "Chicken Broth": .broth, "Beef Broth": .broth, "Vegetable Broth": .broth
        ]


    // MARK: - Normalizer
    private static func norm(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
         .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
         .replacingOccurrences(of: "’", with: "'")
    }

    // MARK: - Subcategory lookup with smart fallbacks
    static func subcategory(for ingredient: String, in category: IngredientCategory) -> IngredientSubcategory {
        let key = norm(ingredient)

        if let explicit = explicitSubcategories[key] { return explicit }

        let l = key.lowercased()
        switch category {
        case .produce:
            if l.contains("berry") || ["apple","apples","banana","bananas","grape","grapes","mango","kiwi","pineapple","tomato","tomatoes","avocado","avocados","orange","oranges","pomegranate"].contains(l) {
                return .fruit
            }
            if ["basil","cilantro","parsley","dill","scallions","chives"].contains(l) { return .herb }
            return .vegetable

        case .grains:
            if l.contains("pasta") || ["spaghetti","penne","rigatoni","fettuccine","linguine","macaroni","gnocchi"].contains(l) { return .pasta }
            if l.contains("noodle") || l.contains("ramen") || l.contains("udon") || l.contains("vermicelli") { return .noodle }
            if l.contains("oat") { return .oats }
            if l.contains("rice") { return .rice }
            if l.contains("tortilla") { return .tortilla }
            if l.contains("bread") || l.contains("bagel") || l.contains("muffin") || l.contains("dough") { return .bread }
            if l.contains("flour") || l.contains("crust") { return .flour }
            if l.contains("cereal") || l.contains("cracker") { return .cereal }
            return .grainOther

        case .meatFish:
            if ["salmon","mackerel","sardines","tilapia","cod","tuna","fish","shrimp","prawn","crab","lobster","scallop"].contains(l) { return .fish }
            if ["chicken","chicken breast","chicken breasts","chicken thighs","turkey","turkey legs"].contains(l) { return .poultry }
            if ["beef","steak","ground beef","pork","lamb","ground lamb","bacon","liver"].contains(l) { return .redMeat }
            if ["ham","prosciutto","pancetta"].contains(l) { return .deli }
            return .meatOther

        case .dairy:
            if l.contains("yogurt") { return .yogurt }
            if l == "milk" || l.contains("milk ") || l.contains("almond milk") || l.contains("kefir") { return .milk }
            if l.contains("cheese") || ["parmesan","feta","mozzarella","cheddar","provolone","stilton","goat cheese","swiss cheese"].contains(l) { return .cheese }
            if l.contains("butter") || l.contains("ghee") || l.contains("sour cream") || l.contains("cream cheese") { return .butter }
            return .dairyOther

        case .herbsSpices:
            if l.contains("syrup") || l == "honey" || l == "vanilla extract" { return .sweetener }
            if l.contains("broth") || l.contains("stock") { return .broth }
            if l.contains("sauce") || l.contains("paste") || l.contains("miso") || l.contains("tahini") || l.contains("ketchup") || l.contains("mustard") { return .sauce }
            return .spice

        case .saucesBroth:
            if l.contains("broth") || l.contains("stock") { return .broth }
            return .sauce

        case .other:
            if l.contains("Frozen Mixed Berries") || l.contains("Frozen Mixed Berries") { return .other }
            return .other
        }
    }

    // MARK: - Sort items inside a section by subcategory, then A–Z
    static func sortedBySubcategory(_ items: [String], in category: IngredientCategory) -> [String] {
        let order = subcategoryOrderByCategory[category] ?? [.other]
        func sortKey(_ name: String) -> (Int, String) {
            let sub = subcategory(for: name, in: category)
            let idx = order.firstIndex(of: sub) ?? order.count
            return (idx, name.lowercased())
        }
        return items.sorted { a, b in
            let ka = sortKey(a), kb = sortKey(b)
            if ka.0 != kb.0 { return ka.0 < kb.0 }   // bucket order first
            return ka.1 < kb.1                       // alpha within bucket
        }
    }

    
    static func category(for ingredient: String) -> IngredientCategory {
        let normalized = ingredient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // Explicit match first (case-insensitive)
        if let exact = explicit.first(where: { $0.key.lowercased() == normalized })?.value {
            return exact
        }

        // Dairy
        if normalized.contains("milk")
            || normalized.contains("cheese")
            || normalized.contains("yogurt")
            || normalized.contains("kefir")
            || normalized.contains("cream")
            || normalized.contains("egg") {
            return .dairy
        }

        // Meat / Fish
        if normalized.contains("chicken")
            || normalized.contains("turkey")
            || normalized.contains("beef")
            || normalized.contains("steak")
            || normalized.contains("pork")
            || normalized.contains("bacon")
            || normalized.contains("ham")
            || normalized.contains("lamb")
            || normalized.contains("salmon")
            || normalized.contains("tilapia")
            || normalized.contains("shrimp")
            || normalized.contains("sardine")
            || normalized.contains("mackerel")
            || normalized.contains("fish") {
            return .meatFish
        }

        // Grains
        if normalized.contains("pasta")
            || normalized.contains("noodle")
            || normalized.contains("rice")
            || normalized.contains("bread")
            || normalized.contains("bagel")
            || normalized.contains("muffin")
            || normalized.contains("tortilla")
            || normalized.contains("flour")
            || normalized.contains("dough")
            || normalized.contains("oat")
            || normalized.contains("cereal")
            || normalized.contains("cracker") {
            return .grains
        }

        // Produce (expanded for common custom entries)
        if normalized.contains("onion")
            || normalized.contains("garlic")
            || normalized.contains("tomato")
            || normalized.contains("pepper")
            || normalized.contains("carrot")
            || normalized.contains("potato")
            || normalized.contains("broccoli")
            || normalized.contains("cauliflower")
            || normalized.contains("spinach")
            || normalized.contains("kale")
            || normalized.contains("lettuce")
            || normalized.contains("cucumber")
            || normalized.contains("zucchini")
            || normalized.contains("asparagus")
            || normalized.contains("mushroom")
            || normalized.contains("celery")
            || normalized.contains("leek")
            || normalized.contains("berry")
            || normalized.contains("banana")
            || normalized.contains("apple")
            || normalized.contains("grape")
            || normalized.contains("mango")
            || normalized.contains("kiwi")
            || normalized.contains("pineapple")
            || normalized.contains("avocado")
            || normalized.contains("orange")
            || normalized.contains("lemon")
            || normalized.contains("lime") {
            return .produce
        }

        // Herbs / Spices
        if normalized.contains("seasoning")
            || normalized.contains("spice")
            || normalized.contains("powder")
            || normalized.contains("basil")
            || normalized.contains("parsley")
            || normalized.contains("cilantro")
            || normalized.contains("dill")
            || normalized.contains("oregano")
            || normalized.contains("thyme")
            || normalized.contains("rosemary") {
            return .herbsSpices
        }

        // Sauces / Broth
        if normalized.contains("salsa")
            || normalized.contains("paste")
            || normalized.contains("broth")
            || normalized.contains("stock")
            || normalized.contains("sauce")
            || normalized.contains("miso")
            || normalized.contains("mustard")
            || normalized.contains("ketchup")
            || normalized.contains("mayo")
            || normalized.contains("mayonnaise") {
            return .saucesBroth
        }

        return .other
    }

}
