//
//  Question+CoreDataProperties.swift
//  
//
//  Created by Jakub Juh on 14/11/2020.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var questionName: String?
    @NSManaged public var asnwers: [Answer]?

}
