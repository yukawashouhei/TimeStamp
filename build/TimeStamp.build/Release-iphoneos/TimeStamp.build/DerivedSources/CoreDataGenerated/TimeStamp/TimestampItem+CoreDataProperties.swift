//
//  TimestampItem+CoreDataProperties.swift
//  
//
//  Created by 湯川昇平 on 2025/08/21.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TimestampItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimestampItem> {
        return NSFetchRequest<TimestampItem>(entityName: "TimestampItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?

}

extension TimestampItem : Identifiable {

}
