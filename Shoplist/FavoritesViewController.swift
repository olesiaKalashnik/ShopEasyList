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
        self.favoriteItems = favoriteItems.sorted { (item1, item2) -> Bool in
            item1.numOfPurchaces > item2.numOfPurchaces
        }
    }
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundView = UIImageView(image: UIImage(imageLiteralResourceName: Defaults.UI.textureImage))
        for item in self.navigationItem.rightBarButtonItems! {
            item.tintColor = Defaults.UI.blueSolid
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAppearance()
    }
    
    //MARK: - @IBActions
    @IBAction func doneButtonSelected(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - TableView DataSource Methods
extension FavoritesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UncategorizedTableViewCell.id, for: indexPath) as! UncategorizedTableViewCell
        cell.libraryItem = self.favoriteItems[(indexPath as NSIndexPath).row]
        return cell
    }
}
