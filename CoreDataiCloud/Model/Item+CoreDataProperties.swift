//
//  Item+CoreDataProperties.swift
//  CoreDataiCloud
//
//  Created by Hao Yu Yeh on 2023/11/2.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?

}

extension Item : Identifiable {

}
