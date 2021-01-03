//
//  randName.swift
//  sprite-snake
//
//  Created by tzx on 2021/1/1.
//  Copyright © 2021 frezcirno. All rights reserved.
//

import Foundation

public extension String {

    static func randName() -> String {
        let names = ["Gabrielle", "Wright",
                     "Owen", "Ferguson", "Maria", "Knox",
                     "Sally", "Randall", "Kevin", "Walker",
                     "Brandon", "Morgan", "Kimberly", "Clark",
                     "Faith", "Lee", "Adrian", "May",
                     "Adrian", "Morgan", "Connor", "McGrath",
                     "Dylan", "Bell", "Jasmine", "Cameron",
                     "Emma", "Rees", "Caroline", "Walsh",
                     "Joshua", "Stewart", "Samantha", "Forsyth",
                     "Brandon", "Simpson", "Alan", "Burgess",
                     "Piers", "Graham"]
        return names[Int.random(in: 0..<names.count)]
    }
}
