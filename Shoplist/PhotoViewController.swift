//
//  PhotoViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController  {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    var image : UIImage?
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAppearance()
    }
    
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseFromAlbum(sender: UIBarButtonItem) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelImagePicker(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// UIImagePickerControllerDelegate Methods
extension PhotoViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            guard let data = UIImageJPEGRepresentation(image, 0.1) else {
                self.dismissViewControllerAnimated(true, completion: nil)
                return }
            self.image = UIImage(data: data)
            //self.image = image
            self.imageView.image = self.image
            if let navController = presentingViewController as? UINavigationController {
                if let addVC = navController.viewControllers.first as? AddItemTableViewController {
                    
                    addVC.image = self.image
                    addVC.imageView.image = self.image
                }
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: - Setup Methods
extension PhotoViewController : Setup {
    func setup() {
        self.imagePicker.delegate = self
        self.navigationController?.navigationBar.barTintColor = Defaults.UI.blueSolid
    }
    
    func setupAppearance() {
        if let existingImage = self.imageView?.image {
            self.image = existingImage
        }
        if let safeImage = image {
            self.imageView?.image = safeImage
        }
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
}
