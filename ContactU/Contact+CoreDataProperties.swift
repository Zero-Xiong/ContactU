//
//  Contact+CoreDataProperties.swift
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

extension Contact {

    @NSManaged var identifier: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var contactImage: NSData?
    @NSManaged var contact_todoitem: NSSet?

}
