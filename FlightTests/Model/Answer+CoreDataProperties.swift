//
//  Answer+CoreDataProperties.swift
//  
//
//  Created by Jakub Juh on 14/11/2020.
//
//

import Foundation
import CoreData


extension Answer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answer> {
        return NSFetchRequest<Answer>(entityName: "Answer")
    }

    @NSManaged public var name: String?
    @NSManaged public var isTrue: Bool

}
