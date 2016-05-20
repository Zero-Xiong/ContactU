//
//  AddContactTableViewController.swift
//  ContactU
//
//  Created by xiong on 20/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import UIKit
import CoreData

class AddContactTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var firstNameText: UITextField!
    @IBOutlet var lastNameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var phoneText: UITextField!
    @IBOutlet var contactImageView: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        contactImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func chooseImage(recognizer: UITapGestureRecognizer) {
        let imagePicker : UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self ;
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        contactImageView.image = pickedImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func addContact(sender: AnyObject) {
        let moc: NSManagedObjectContext = CoreDataHelper.managedObjectContext()
        
        let contact: Contact = CoreDataHelper.insertManagedObject(NSStringFromClass(Contact), managedObjectConect: moc) as! Contact
        
        contact.identifier = "\(NSDate())"
        contact.firstName = firstNameText.text
        contact.lastName = lastNameText.text
        contact.email = emailText.text
        contact.phone = phoneText.text
        
        let contactImageData: NSData = UIImagePNGRepresentation(contactImageView.image!)!
        
        contact.contactImage = contactImageData
        
        CoreDataHelper.saveManagedObjectContext(moc)
        
        self.navigationController?.popViewControllerAnimated(true)

    }

    @IBAction func cancelAddContact(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)

    }
}
