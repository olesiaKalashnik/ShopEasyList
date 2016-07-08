//
//  Defaults.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/30/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class Defaults {
    
    private enum AllCategories : String {
        case None = "None"
        case BakedGoods = "Baked Goods"
        case BeautyHealth = "Beauty & Health"
        case Beverages = "Beverages"
        case CannedGoods = "Canned Goods"
        case Dairy = "Dairy"
        case Dressings = "Dressings & Condiments"
        case Produce = "Produce"
        case HouseholdCleaning = "House & Cleaning"
        case MeatFish = "Meat & Fish"
        case Snacks = "Snacks"
        case Sweets = "Sweets"
    }
    
    static let allCategories = ["None", "Baked Goods", "Beauty & Health", "Beverages", "Canned Goods", "Dairy", "Dressings & Condiments", "Household & Cleaning", "Meat & Fish", "Produce", "Snacks", "Sweets"]
    
    struct UI {
        static let textureImage = "texture1"
        static let blueSolid = UIColor(red: 50/255, green: 170/255, blue: 240/255, alpha: 1)
        static let blueTransperent = UIColor(red: 50/255, green: 170/255, blue: 240/255, alpha: 0.4)
        static let recentsFavoritsRowHeight = CGFloat(55.0)
        static let libraryCellWithImageHeight = CGFloat(60.0)
        static let detailsRowHeight = CGFloat(55.0)
        static let noDetailsRowHeight = CGFloat(44.0)
    }
}