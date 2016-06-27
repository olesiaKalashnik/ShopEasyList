//
//  LibraryItem.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

class LibraryItem {
    let name: String
    let isInList : Bool
    let category : String
    
    init(name: String, category: String, inList: Bool = true) {
        self.name = name
        self.category = category
        self.isInList = inList
    }
}
