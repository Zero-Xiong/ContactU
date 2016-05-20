//
//  CoreDataHelper.swift
//  ContactU
//
//  Created by xiong on 20/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//


import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    class func directoryForDatabaseFilename()->NSString{
        return NSHomeDirectory().stringByAppendingString("/Library/Private Documents")
    }
    
    
    class func databaseFilename()->NSString{
        return "database.sqlite";
    }
    
    class func managedObjectContext()->NSManagedObjectContext{
        
        
        do { try NSFileManager.defaultManager().createDirectoryAtPath(CoreDataHelper.directoryForDatabaseFilename() as String, withIntermediateDirectories: true, attributes: nil) }
        catch {
            print("Error Creating Directory for DB")
        }
        //        NSFileManager.defaultManager().createDirectoryAtPath(SwiftCoreDataHelper.directoryForDatabaseFilename(), withIntermediateDirectories: true, attributes: nil, error: &error)
        
        let path:NSString = "\(CoreDataHelper.directoryForDatabaseFilename()) + \(CoreDataHelper.databaseFilename())"
        
        let url:NSURL = NSURL(fileURLWithPath: path as String)
        
        let managedModel:NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)!
        
        let storeCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        
        do {
            try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            print("Error: \(error)")
            
        }
        //        if !storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil){
        //            if (error != nil){
        //                print(error!.localizedDescription)
        //                abort()
        //            }
        //        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        
        return managedObjectContext
        
        
    }
    
    class func insertManagedObject(className:NSString, managedObjectConect:NSManagedObjectContext)->AnyObject{
        
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(className as String, inManagedObjectContext: managedObjectConect) as NSManagedObject
        
        return managedObject
        
    }
    
    class func saveManagedObjectContext(managedObjectContext:NSManagedObjectContext)->Bool{
        do {
            try managedObjectContext.save()
            return true
        } catch _ {
            return false
        }
    }
    
    
    class func fetchEntities(className:NSString, withPredicate predicate:NSPredicate?, managedObjectContext:NSManagedObjectContext)->NSArray{
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        
        let entetyDescription:NSEntityDescription = NSEntityDescription.entityForName(className as String, inManagedObjectContext: managedObjectContext)!
        
        
        fetchRequest.entity = entetyDescription
        if (predicate != nil){
            fetchRequest.predicate = predicate!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        var items = NSArray()
        do { items = try managedObjectContext .executeFetchRequest(fetchRequest)
        } catch {
            print("Fetch Request Failed")
        }
        return items
    }
    
    
}
