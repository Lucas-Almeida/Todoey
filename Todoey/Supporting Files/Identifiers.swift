//
//  Identifiers.swift
//  Todoey
//
//  Created by Lucas Almeida on 26/01/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import Foundation

enum Identifiers: String {
    case PrototypeCellId = "toDoItemCell"
}

enum Persistence: String {
    case UserDefaultsItemArray = "TodoListArray"
}

enum Pathing: String {
    case ItemsPlist = "Items.plist"
}

enum Entities: String {
    case Item = "Item"
}
