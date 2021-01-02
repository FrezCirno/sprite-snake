//
//  ColliderType.swift
//  sprite-snake
//
//  Created by tzx on 2021/1/2.
//  Copyright © 2021 frezcirno. All rights reserved.
//

import Foundation

struct Category: OptionSet {
    let rawValue: UInt32
    
    static let Detector = Category(rawValue: 1 << 0)
    static let Sections = Category(rawValue: 1 << 1)
    static let Head = Category(rawValue: 1 << 2)
    static let Food = Category(rawValue: 1 << 3)
}
