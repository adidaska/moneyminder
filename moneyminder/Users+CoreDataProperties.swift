//
//  Users+CoreDataProperties.swift
//  moneyminder
//
//  Created by Martin Graham on 8/10/16.
//  Copyright © 2016 MeG Studios. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Users {

    @NSManaged var name: String?
    @NSManaged var createdDate: NSDate?
    @NSManaged var updatedDate: NSDate?
    @NSManaged var userPhoto: String?
    @NSManaged var balance: NSDecimalNumber?
    @NSManaged var transactions: NSSet?

}
