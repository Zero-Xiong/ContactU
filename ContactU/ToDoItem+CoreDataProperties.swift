//
//  ToDoItem+CoreDataProperties.swift
//  ContactU
//
//  Created by xiong on 20/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ToDoItem {

    @NSManaged var identifier: String?
    @NSManaged var note: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var contact: Contact?

}
