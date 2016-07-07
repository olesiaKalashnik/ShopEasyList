//
//  NoDetailsListItemTableViewCell.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/6/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class NoDetailsListItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completionButton: CheckboxButton!
    @IBOutlet weak var nameLabel: UILabel!
    var cellHeight = 44
    
    var listItem : Item? {
        didSet {
            self.setup()
        }
    }
    
    @IBAction func completionChecked(sender: CheckboxButton) {
        completionButton.selected = !completionButton.selected
        guard let item = self.listItem else { return }
        item.isCompleted = sender.selected
    }
}

extension NoDetailsListItemTableViewCell : Setup {
    func setup() {
        guard let item = self.listItem else { return }
        self.nameLabel?.text = item.name
        self.completionButton.selected = item.isCompleted
    }
    
    func setupAppearance() {
        
    }
}
