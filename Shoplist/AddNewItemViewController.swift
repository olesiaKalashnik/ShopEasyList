//
//  AddNewItemViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class AddNewItemViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var tableView: UITableView?
    
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    let library = Library.shared
    var image : UIImage?
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.title = "Done"
        self.tableView = self.containerView.subviews.first as? UITableView
        for cell in (self.tableView?.visibleCells)! {
            print(cell)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: @IBActions
    @IBAction func saveNewItem(sender: UIBarButtonItem) {
        var item : Item
        if let newItem = self.nameTextField.text {
            if newItem != "" {
                if let inxPath = self.tableView?.indexPathForSelectedRow {
                    let selectedCategory = Defaults.allCategories[inxPath.row]
                    item = Item(name: newItem, category: selectedCategory)
                } else {
                    item = Item(name: newItem, category: "None")
                }
                item.isInList = true
                item.isCompleted = false
                item.numOfPurchaces = 0
                item.detailsText = detailsTextField.text
                item.image = self.image
                print(item.image)
                library.add(item)
                library.saveObjects()
            }
        }
        self.nameTextField.text = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Keyboard Handling
    func keyboardWillShow(notification: NSNotification) {
        if self.detailsTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.detailsTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

//MARK: TextFieldDelegate Methods
extension AddNewItemViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.title = "Save"
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == nil || textField.text == "" {
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: UITableViewDelegate Methods
extension AddNewItemViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        tableView.cellForRowAtIndexPath(indexPath)?.selectionStyle = UITableViewCellSelectionStyle.Blue
        return indexPath
    }
}
