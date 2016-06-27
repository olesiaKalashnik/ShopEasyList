//
//  ListViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, Identity {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    var datasource : List? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addListItem(sender: UIBarButtonItem) {
    }
    
}

extension ListViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ListItemTableViewCell.id, forIndexPath: indexPath) as! ListItemTableViewCell
        return cell
    }
    
}

extension ListViewController : UITableViewDelegate {
    
}

