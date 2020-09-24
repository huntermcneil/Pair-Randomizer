//
//  Person.swift
//  Pair Randomizer
//
//  Created by Hunter McNeil on 7/10/20.
//  Copyright © 2020 Hunter McNeil. All rights reserved.
//

import Foundation

class Person: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
    }
}
