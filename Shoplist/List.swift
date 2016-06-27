//
//  List.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

class List {
    var items : [ListItem]
    
    init(listItems: [ListItem]) {
        self.items = listItems
    }
}