//
//  UncategorizedTableViewCell.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/5/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class UncategorizedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completionCheckbox: CheckboxButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var currList : List?
    
    var libraryItem : Item? {
        didSet {
            self.setup()
        }
    }
    
    @IBAction func completionChecked(_ sender: CheckboxButton) {
        sender.isSelected = !sender.isSelected
        libraryItem?.list = sender.isSelected ? currList : nil
        libraryItem?.isCompleted = false
    }
}

extension UncategorizedTableViewCell : Setup {
    func setup() {
        guard let item = self.libraryItem else { return }
        self.nameLabel?.text = item.name.lowercased()
        self.categoryLabel?.text = item.category
        if let currList = item.list {
            self.completionCheckbox.isSelected = Library.shared.itemsInList(list: currList).contains(item)
        }
    }
    
    func setupAppearance() {
        //
    }
}
