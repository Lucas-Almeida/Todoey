//
//  Data.swift
//  Todoey
//
//  Created by Lucas Almeida on 13/02/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
