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
    case CategoryCell = "CategoryCell"
}

enum Persistence: String {
    case UserDefaultsItemArray = "TodoListArray"
}

enum Pathing: String {
    case ItemsPlist = "Items.plist"
}

enum Entities: String {
    case Item = "Item"
    case Category = "Category"
}

enum ItemPredicates: String {
    case Title = "title"
    case Done = "done"
}

enum StoryboardSegues: String {
    case ItemsView = "goToItems"
}
