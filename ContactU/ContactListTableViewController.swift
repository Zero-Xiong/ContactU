//
//  ContactListTableViewController.swift
//  ContactU
//
//  Created by xiong on 20/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import UIKit

import CoreData

class ContactListTableViewController: UITableViewController {
    var contacts : NSMutableArray = NSMutableArray()
    var delegate : ContactSelectionDelegate? = nil
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    func loadData() {
        contacts.removeAllObjects()
        
        let moc:NSManagedObjectContext = CoreDataHelper.managedObjectContext()
        
        let results:NSArray = CoreDataHelper.fetchEntities(NSStringFromClass(Contact), withPredicate: nil, managedObjectContext: moc)
        
        for contact in results{
            let singleContact:Contact = contact as! Contact
            
            let contactDict:NSDictionary = ["identifier":singleContact.identifier!,"firstName":singleContact.firstName!, "lastName":singleContact.lastName!,"email":singleContact.email!,"phone":singleContact.phone!,"contactImage":singleContact.contactImage!]
            
            contacts.addObject(contactDict)
            
        }
        
        self.tableView.reloadData()
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count ;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ContactListTableViewCell =  tableView.dequeueReusableCellWithIdentifier("mycontactlistCell", forIndexPath: indexPath) as! ContactListTableViewCell
        
        if ( indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        
        let contactDict:NSDictionary = contacts.objectAtIndex(indexPath.row) as! NSDictionary
        
        let firstName = contactDict.objectForKey("firstName") as! String
        let lastName = contactDict.objectForKey("lastName") as! String
        let mail = contactDict.objectForKey("email") as! String
        let phone = contactDict.objectForKey("phone") as! String
        let imageData:NSData = contactDict.objectForKey("contactImage") as! NSData
        
        let contactImage:UIImage = UIImage(data: imageData)!
        
        cell.nameLabel.text = firstName + " " + lastName
        cell.phoneLabel.text = phone
        cell.emailLabel.text = mail
        cell.contactImageView.image = contactImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (delegate != nil) {
            let contactDic: NSDictionary = contacts.objectAtIndex(indexPath.row) as! NSDictionary
            
            delegate?.userDidSelectContact(contactDic.objectForKey("identifier") as! NSString)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}

protocol ContactSelectionDelegate {
    func userDidSelectContact(contactIdentifier: NSString)
}
