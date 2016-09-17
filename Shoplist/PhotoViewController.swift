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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAppearance()
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseFromAlbum(_ sender: UIBarButtonItem) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelImagePicker(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// UIImagePickerControllerDelegate Methods
extension PhotoViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            guard let data = UIImageJPEGRepresentation(image, 0.1) else {
                self.dismiss(animated: true, completion: nil)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
}
