//
//  Helper.swift
//  To Do List
//
//  Created by Akash Desai on 5/26/17.
//  Copyright © 2017 DopamineLabs. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static func rand(max: UInt32) -> Int {
        return Int(arc4random_uniform(max)+1)
    }
}

