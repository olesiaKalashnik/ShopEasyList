//
//  RecentsViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/5/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var library = Library.shared
    var recentItems = Library.shared.items.filter({$0.lastTimeAddedToList != nil})
        {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    func setupAppearance() {
        self.tableView.rowHeight = Defaults.UI.recentsFavoritsRowHeight
        self.recentItems = library.items.filter({$0.lastTimeAddedToList != nil})
        self.recentItems = recentItems.sorted { (item1, item2) -> Bool in
            item1.lastTimeAddedToList!.compare(item2.lastTimeAddedToList! as Date) == ComparisonResult.orderedDescending
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
extension RecentsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UncategorizedTableViewCell.id, for: indexPath) as! UncategorizedTableViewCell
        cell.libraryItem = self.recentItems[(indexPath as NSIndexPath).row]
        return cell
    }
}
