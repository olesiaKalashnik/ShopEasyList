//
//  ListItem.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

class ListItem {
    let inLibrary : LibraryItem
    var details : Details?
    var isCompleted : Bool
    
    init(inLibrary: LibraryItem, details: Details? = nil, isCompleted: Bool = false) {
        self.inLibrary = inLibrary
        self.details = details
        self.isCompleted = isCompleted
    }
}