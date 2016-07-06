//
//  AddItemTableViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/4/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    
    var item : Item?
    @IBOutlet weak var addImageButton: UIButton!
    let library = Library.shared
    var image : UIImage?
    var category : String?
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.title = "Done"
        self.addImageButton?.layer.cornerRadius = 3.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    //MARK: @IBActions
    @IBAction func saveNewItem(sender: UIBarButtonItem) {
        if let newItem = self.nameTextField.text {
            if newItem != "" {
                if let selectedCategory = self.category {
                    item = Item(name: newItem, category: selectedCategory)
                } else {
                    item = Item(name: newItem, category: "None")
                }
                item!.isInList = true
                item!.isCompleted = false
                item!.numOfPurchaces = 0
                item!.detailsText = detailsTextField.text
                item!.image = self.image
                
                library.editDetails(item!)
                library.add(item!)
                library.saveObjects()
            }
        }
        self.nameTextField.text = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func Cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - TableView DataSource Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Category"
        } else if section == 2 {
            return "Image"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsBySection = [2, 12, 1]
        return rowsBySection[section]
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            self.category = Defaults.allCategories[indexPath.row]
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            self.category = Defaults.allCategories[indexPath.row]
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if item != nil && indexPath.section == 1 {
            return nil
        }
        return indexPath
    }
}

//MARK: TextFieldDelegate Methods
extension AddItemTableViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.title = "Save"
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if nameTextField.text == nil || nameTextField.text == "" {
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddItemTableViewController : Setup {
    func setup() {
        if item != nil {
            self.nameTextField.enabled = false
            self.nameTextField.text = item?.name
            self.detailsTextField.text = item?.detailsText
            self.category = item?.category
            self.imageView?.image = item?.image
            
        } else {
            self.nameTextField.enabled = true
        }
    }
    
    func setupAppearance() {
        //
    }
    
    
    
}

