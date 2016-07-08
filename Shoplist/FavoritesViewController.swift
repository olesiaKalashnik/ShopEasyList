//
//  FavoritesViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/5/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var library = Library.shared
    var favoriteItems = Library.shared.items.filter({$0.numOfPurchaces > 0}) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    func setupAppearance() {
        self.tableView.rowHeight = Defaults.UI.recentsFavoritsRowHeight
        self.favoriteItems = library.items.filter({$0.numOfPurchaces > 0})
        self.favoriteItems = favoriteItems.sort { (item1, item2) -> Bool in
            item1.numOfPurchaces > item2.numOfPurchaces
        }
    }
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundView = UIImageView(image: UIImage(imageLiteral: Defaults.UI.textureImage))
        for item in self.navigationItem.rightBarButtonItems! {
            item.tintColor = Defaults.UI.blueSolid
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAppearance()
    }
    
    //MARK: - @IBActions
    @IBAction func doneButtonSelected(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: - TableView DataSource Methods
extension FavoritesViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UncategorizedTableViewCell.id, forIndexPath: indexPath) as! UncategorizedTableViewCell
        cell.libraryItem = self.favoriteItems[indexPath.row]
        return cell
    }
}
