//
//  Optifire.swift
//  Optifire
//
//  Created by Ivan Trufanov on 09.02.17.
//  Copyright © 2017 Werbary. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Optifire {
    static let shared = Optifire()
    
    var ref: FIRDatabaseReference!
    
    init() {
        ref = FIRDatabase.database().reference()
    }
}

typealias OptifireSuccess = (_ object: OptifireModel?) -> Void
typealias OptifireFailure = (_ object: OptifireModel?, _ error: Error?) -> Void
