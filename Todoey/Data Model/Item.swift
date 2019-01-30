//
//  Item.swift
//  Todoey
//
//  Created by Lucas Almeida on 28/01/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import Foundation

class Item {
    var title: String = ""
    var done: Bool = false
    
    init(title: String) {
        self.title = title
    }
}
