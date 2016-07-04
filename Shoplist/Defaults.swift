//
//  Defaults.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/30/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

class Defaults {
    
    private enum AllCategories : String {
        case None = "None"
        case BakedGoods = "Baked Goods"
        case BeautyHealth = "Beauty&Health"
        case Beverages = "Beverages"
        case CannedGoods = "Canned Goods"
        case Dairy = "Dairy"
        case Dressings = "Dressings"
        case Produce = "Produce"
        case HouseholdCleaning = "House&Cleaning"
        case MeatFish = "Meat&Fish"
        case Snacks = "Snacks"
        case Sweets = "Sweets"
    }
    
    static let allCategories = ["None", "Baked Goods", "Beauty & Health", "Beverages", "Canned Goods", "Dairy", "Dressings", "Household & Cleaning", "Meat & Fish", "Produce", "Snacks", "Sweets"]
    
    static var defaultLibrary : [Item] {
        let apples = Item(name: "apples", category: AllCategories.Produce.rawValue)
        let shampoo = Item(name: "shampoo", category: AllCategories.BeautyHealth.rawValue)
        let butter = Item(name: "butter", category: AllCategories.Dairy.rawValue)
        let pie = Item(name: "pie", category: AllCategories.BakedGoods.rawValue)
        let bread = Item(name: "bread", category: AllCategories.BakedGoods.rawValue)
        let items = [apples, shampoo, butter, pie, bread]
        return items
    }
}