//
//  HaveToContactTableViewController.swift
//  ContactU
//
//  Created by xiong on 20/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import CoreData
import UIKit
import MessageUI

class HaveToContactTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var toDoItems:NSMutableArray = NSMutableArray()

    
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
    
    func  loadData() {
        toDoItems.removeAllObjects()
        
        let moc:NSManagedObjectContext = CoreDataHelper.managedObjectContext()
        let results:NSArray = CoreDataHelper.fetchEntities(NSStringFromClass(ToDoItem), withPredicate: nil, managedObjectContext: moc)
        
        if results.count > 0 {
            
            for toDo in results{
                let singleToDoItem:ToDoItem = toDo as! ToDoItem
                
                let identifier = singleToDoItem.identifier
                
                let contact:Contact = singleToDoItem.contact! as Contact
                
                let firstName = contact.firstName
                let lastName = contact.lastName
                let email = contact.email
                let phone = contact.phone
                
                let dueDate = singleToDoItem.dueDate
                let title = singleToDoItem.note
                
                let profileImage:UIImage = UIImage(data: contact.contactImage!)!
                
                let dict:NSDictionary = ["identifier":identifier!,"firstName":firstName!, "lastName":lastName!, "email":email!, "phone":phone!, "dueDate":dueDate!, "title":title!, "profileImage":profileImage]
                
                toDoItems.addObject(dict)

            }
            
            let dateDescriptor:NSSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
            let sortedArray:NSArray = toDoItems.sortedArrayUsingDescriptors([dateDescriptor])
            
            toDoItems = NSMutableArray(array: sortedArray)
            
            
            self.tableView.reloadData()
        }

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return toDoItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:HaveToContactTableViewCell = tableView.dequeueReusableCellWithIdentifier("havetocontactCell", forIndexPath: indexPath) as! HaveToContactTableViewCell
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        
        let infoDict:NSDictionary = toDoItems.objectAtIndex(indexPath.row) as! NSDictionary
        
        let firstName:NSString = infoDict.objectForKey("firstName") as! NSString
        let lastName:NSString = infoDict.objectForKey("lastName") as! NSString
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        
        let dateString:NSString = dateFormatter.stringFromDate(infoDict.objectForKey("dueDate") as! NSDate)
        
        cell.contactImageView.image = infoDict.objectForKey("profileImage") as? UIImage
        cell.nameLabel.text = (firstName as String) + " " + (lastName as String)
        cell.titleLabel.text = infoDict.objectForKey("title") as! NSString as String
        cell.dueDateLabel.text = dateString as String
        
        cell.callButton.tag = indexPath.row
        cell.textButton.tag = indexPath.row
        cell.mailButton.tag = indexPath.row
        
        cell.callButton.addTarget(self, action: #selector(callSomeone), forControlEvents: UIControlEvents.TouchUpInside)
        cell.textButton.addTarget(self, action: #selector(textSomeOne), forControlEvents: UIControlEvents.TouchUpInside)
        cell.mailButton.addTarget(self, action: #selector(mailSomeOne), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell

    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            if (toDoItems.count > 0){
                let infoDict:NSDictionary = toDoItems.objectAtIndex(indexPath.row) as! NSDictionary
                
                let moc:NSManagedObjectContext = CoreDataHelper.managedObjectContext()
                
                let identifier:NSString = infoDict.objectForKey("identifier") as! NSString
                
                let predicate:NSPredicate = NSPredicate(format: "identifier == '\(identifier)'")
                
                let results:NSArray = CoreDataHelper.fetchEntities(NSStringFromClass(ToDoItem), withPredicate: predicate, managedObjectContext: moc)
                
                let toDoItemToDelete:ToDoItem = results.lastObject as! ToDoItem
                
                toDoItemToDelete.managedObjectContext!.deleteObject(toDoItemToDelete)
                
                CoreDataHelper.saveManagedObjectContext(moc)
              
                loadData()
                self.tableView.reloadData()
            }
            
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    func callSomeone(sender: UIButton)  {
       print("callSomeone")
        
        let infoDict : NSDictionary = toDoItems.objectAtIndex(sender.tag) as! NSDictionary
        
        let phoneNumber = infoDict.objectForKey("phone") as! NSString
        
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(phoneNumber)")!)
    }
    
    func textSomeOne(sender: UIButton)  {
        print("textSomeOne")
        
        let infoDict:NSDictionary = toDoItems.objectAtIndex(sender.tag) as! NSDictionary
        let phoneNumber = infoDict.objectForKey("phone") as! NSString
        
        if MFMessageComposeViewController.canSendText() {
            let messageController:MFMessageComposeViewController = MFMessageComposeViewController()
            messageController.recipients = ["\(phoneNumber)"]
            messageController.messageComposeDelegate = self
            
            self.presentViewController(messageController, animated: true, completion: nil)
            
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        
        
        // Does not work in Beta 4
        switch result{
         case MessageComposeResultSent:
         controller.dismissViewControllerAnimated(true, completion: nil)
         case MessageComposeResultCancelled:
         controller.dismissViewControllerAnimated(true, completion: nil)
         default:
         controller.dismissViewControllerAnimated(true, completion: nil)
         }
        
        
    }

    func mailSomeOne(sender: UIButton)  {
        print("mailSomeOne")
        
        let infoDict:NSDictionary = toDoItems.objectAtIndex(sender.tag) as! NSDictionary
        let email = infoDict.objectForKey("email") as! NSString
        
        if MFMailComposeViewController.canSendMail() {
            let messageController:MFMailComposeViewController = MFMailComposeViewController()
            messageController.setToRecipients(["\(email)"])
            messageController.mailComposeDelegate = self
            
            self.presentViewController(messageController, animated: true, completion: nil)
            
        }

        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        
        
        // Does not work in Beta 4
        switch result {
         case MFMailComposeResultCancelled:
         controller.dismissViewControllerAnimated(true, completion: nil)
         case MFMailComposeResultSent:
         controller.dismissViewControllerAnimated(true, completion: nil)
         default:
         controller.dismissViewControllerAnimated(true, completion: nil)
         
         }
        
    }
    


}
