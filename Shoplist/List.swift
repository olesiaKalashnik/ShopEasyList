//
//  List.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 10/18/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

class List : ItemStoreProtocol {
    
    var items: [Item]
    var name = "New List"
    var id : String?
    
    init(items: [Item]) {
        self.items = items
    }
    
}
