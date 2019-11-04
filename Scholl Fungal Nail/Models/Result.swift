//
//  Result.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 04/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import Foundation
import RealmSwift

class Result : Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var resultClassification: String = ""
    @objc dynamic var resultAccuracy: Float = 0.0
    @objc dynamic var dateAdded: Date?
    @objc dynamic var image: NSData?
    //var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

    override static func primaryKey() -> String? {
        return "id"
    }
}
