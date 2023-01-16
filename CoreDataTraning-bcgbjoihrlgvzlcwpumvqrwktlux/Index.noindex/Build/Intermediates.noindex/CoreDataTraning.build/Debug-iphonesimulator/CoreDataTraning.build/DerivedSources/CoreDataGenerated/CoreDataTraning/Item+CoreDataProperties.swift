//
//  Item+CoreDataProperties.swift
//  
//
//  Created by mobin on 1/13/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var date: Date?
    @NSManaged public var image: Data?
    @NSManaged public var itemID: UUID?
    @NSManaged public var name: String?

}

extension Item : Identifiable {

}
