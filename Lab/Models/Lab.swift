//
//  Lab.swift
//  Lab
//
//  Created by Utsav Dave on 2020-05-08.
//  Copyright © 2020 Utsav Dave. All rights reserved.
//

import Foundation
import RealmSwift

class Lab: Object
{
    // Define properties of Lab model
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    @objc dynamic var location = ""
    
    // Create a function to store Lab inside Realm Database
    static func createLab(withName name: String,withLocation location: String, withDate date: Date) -> Lab {
        let lab = Lab()
        lab.name = name
        lab.date = date
        lab.location = location
        return lab
    }
    
    // This function would return all the labs which are inside Realm Database
    static func all(in realm: Realm = try! Realm()) -> Results<Lab> {
      return realm.objects(Lab.self)
    }
}
