//
//  AddItemViewController.swift
//  ContactU
//
//  Created by xiong on 20/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, ContactSelectionDelegate {
    
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var purposeText: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    var pickedDate: NSDate? = nil
    var contactIdentifier: NSString? = nil
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = "Your"
        lastNameLabel.text = "Contact"
        pickedDate = datePicker.date
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func userDidSelectContact(contactIdentifier: NSString) {
        self.contactIdentifier  = contactIdentifier
        
        let moc: NSManagedObjectContext = CoreDataHelper.managedObjectContext()
        let predicate: NSPredicate = NSPredicate(format: "identifier == '\(self.contactIdentifier!)'")
        
        let results: NSArray = CoreDataHelper.fetchEntities(NSStringFromClass(Contact), withPredicate: predicate, managedObjectContext: moc)
        
        let contact: Contact = results.lastObject as! Contact
        
        contactImageView.image = UIImage(data: contact.contactImage!)
        firstNameLabel.text = contact.firstName
        lastNameLabel.text = contact.lastName
        
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        pickedDate = sender.date
    }
    
    @IBAction func doneAddItem(sender: AnyObject) {
        let moc: NSManagedObjectContext = CoreDataHelper.managedObjectContext()
        let predicate: NSPredicate = NSPredicate(format: "identifier == '\(self.contactIdentifier!)'")
        
        let results: NSArray = CoreDataHelper.fetchEntities(NSStringFromClass(Contact), withPredicate: predicate, managedObjectContext: moc)
        
        let contact: Contact = results.lastObject as! Contact
        
        let toDoItem: ToDoItem = CoreDataHelper.insertManagedObject(NSStringFromClass(ToDoItem), managedObjectConect: moc) as! ToDoItem
        
        toDoItem.identifier = "\(NSDate())"
        toDoItem.note = purposeText.text
        toDoItem.dueDate = pickedDate
        
        toDoItem.contact = contact
        
        CoreDataHelper.saveManagedObjectContext(moc)
        
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( segue.identifier == "contactsSegue") {
            let viewController : ContactListTableViewController = segue.destinationViewController as! ContactListTableViewController
            
            viewController.delegate = self
        }
    }
}
