//
//  ListItemTableViewCell.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell, Identity {

    @IBOutlet weak var completionButton: CheckboxButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var listItem : ListItem? {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        guard let item = self.listItem else { return }
        self.nameLabel?.text = item.inLibrary.name
        self.completionButton.selected = item.isCompleted
        guard let details = item.details else { return }
        self.detailsLabel?.text = details.detailText
    }

}
