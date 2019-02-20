//
//  Category.swift
//  Todoey
//
//  Created by Lucas Almeida on 13/02/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String?
    let items = List<Item>()
}
