//
//  String.swift
//  Todoey
//
//  Created by Lucas Almeida on 20/02/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
