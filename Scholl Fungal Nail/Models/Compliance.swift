//
//  Compliance.swift
//  Scholl Fungal Nail
//
//  Created by Timothy Platt on 05/11/2019.
//  Copyright © 2019 Timothy Platt. All rights reserved.
//

import Foundation
import RealmSwift

class Compliance : Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var takenMedication: Bool = false
    @objc dynamic var dateTaken: Date?
    //var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

    override static func primaryKey() -> String? {
        return "id"
    }
}
