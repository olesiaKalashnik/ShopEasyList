//
//  Details.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class Details {
    var detailText: String
    var image: UIImage?
    
    init(text: String, image: UIImage? = nil) {
        self.detailText = text
        self.image = image
    }
}