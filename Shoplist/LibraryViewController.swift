//
//  LibraryViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/30/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBarItem: UIBarButtonItem!
    
    var library = Library.shared {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var currentList = Library.shared.getSelectedItems()
    var listVC: ListViewController?
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAppearance()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.currentList += updateListWithSelectedItems()
        library.saveObjects()
    }
    
    @IBAction func doneButtonSelected(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: ListViewControllerDelegate Methods
    func updateListWithSelectedItems() -> [Item] {
        let selectedItems = self.library.items.filter {$0.isInList}
        if self.currentList.count > 0 {
            var itemsToBeAdded = [Item]()
            for item in selectedItems {
                if !self.currentList.contains({($0.category == item.category) && ($0.name == item.name)}) {
                    itemsToBeAdded.append(item)
                }
            }
            return itemsToBeAdded
        } else {
            return selectedItems
        }
    }
    
}

//MARK: TableView DataSource Methods
extension LibraryViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Set(library.categories).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = library.groupedItemsAsList[section].first else {return nil}
        return item.category
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = library.categoryToItemDictionary[library.categoryToItemDictionary.keys.map({$0})[section]] else { return 0 }
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LibraryTableViewCell.id, forIndexPath: indexPath) as! LibraryTableViewCell
        var allItemsBySection = library.groupedItemsAsList
        cell.libraryItem = allItemsBySection[indexPath.section][indexPath.row]
        return cell
    }
}

//MARK: Setup Methods
extension LibraryViewController : Setup {
    func setup() {
        self.navigationItem.title = "Library"
    }
    
    func setupAppearance() {
        if let list = listVC?.items {
            self.currentList = list
            self.currentList += updateListWithSelectedItems()
            for item in library.items {
                if self.currentList.count > 0 {
                    item.isInList = self.currentList.contains({($0.category == item.category) && ($0.name == item.name)})
                }
            }
        }
    }
}