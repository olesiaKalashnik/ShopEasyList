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
    
    var currList : List?

    var itemsInCurrentList = [Item]()
    var listVC: ListViewController?
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAppearance()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.itemsInCurrentList += updateListWithSelectedItems() ?? self.itemsInCurrentList
    }
    
    @IBAction func doneButtonSelected(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateListWithSelectedItems() -> [Item]? {
        guard self.currList != nil else {
            return nil
        }
        let selectedItems = self.library.itemsInList(list: self.currList!)
        if self.itemsInCurrentList.count > 0 {
            var itemsToBeAdded = [Item]()
            for item in selectedItems {
                if let itemsInCurrList = self.currList?.items {
                    if !itemsInCurrList.contains(where: {($0.category == item.category) && ($0.name.lowercased() == item.name.lowercased())}) {
                        itemsToBeAdded.append(item)
                    }
                }
            }
            return itemsToBeAdded
        } else {
            return selectedItems
        }
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as UIViewController
        if segue.identifier == AddItemTableViewController.id {
            if let navController = destination as? UINavigationController {
                guard let addVC = navController.visibleViewController as? AddItemTableViewController else { return }
                
                if let indexPath = self.tableView.indexPath(for: sender as!LibraryTableViewCell) {
                    let allItemsBySection = library.groupedItemsAsList
                    addVC.item = allItemsBySection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
                    addVC.currList = self.currList
                }
                
            }
        }
        
    }
    
}

//MARK: TableView DataSource Methods
extension LibraryViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Set(library.categories).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = library.groupedItemsAsList[section].first else {return nil}
        return item.category
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Defaults.UI.blueTransperent
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = library.categoryToItemDictionary[library.categoryToItemDictionary.keys.map({$0})[section]] else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewCell.id, for: indexPath) as! LibraryTableViewCell
        let item = library.groupedItemsAsList[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        if item.image != nil {
            self.tableView.rowHeight = Defaults.UI.libraryCellWithImageHeight
        } else {
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
        cell.libraryItem = item
        cell.currList = self.currList
        return cell
    }
}

//MARK: - TableView Delegate Methods
extension LibraryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let librsaryItemsGrouped = library.groupedItemsAsList
            let itemToBeRemoved = librsaryItemsGrouped[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            itemToBeRemoved.list = nil
            self.library.remove(itemToBeRemoved)
            tableView.reloadData()
        }
    }
}

//MARK: Setup Methods
extension LibraryViewController : Setup {
    func setup() {
        self.navigationItem.title = "Library"
        self.tableView?.backgroundView = UIImageView(image: UIImage(imageLiteralResourceName: Defaults.UI.textureImage))
        for item in self.navigationItem.leftBarButtonItems! {
            item.tintColor = Defaults.UI.blueSolid
        }
        for item in self.navigationItem.rightBarButtonItems! {
            item.tintColor = Defaults.UI.blueSolid
        }
    }
    
    func setupAppearance() {
        if let currList = self.currList {
            self.itemsInCurrentList = Library.shared.itemsInList(list: currList)
        }
        
        
        for cell in self.tableView.visibleCells {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        if let list = listVC?.currentList.items {
            self.itemsInCurrentList = list
            self.itemsInCurrentList += updateListWithSelectedItems() ?? self.itemsInCurrentList
        }
    }
}
