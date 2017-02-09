//
//  Optifire.swift
//  Optifire
//
//  Created by Ivan Trufanov on 09.02.17.
//  Copyright © 2017 Werbary. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class Optifire {
    static let shared = Optifire()
    
    var ref: FIRDatabaseReference!
    
    init() {
        ref = FIRDatabase.database().reference()
    }
}

public typealias OptifireSuccess = (_ object: OptifireModel?) -> Void
public typealias OptifireFailure = (_ object: OptifireModel?, _ error: Error?) -> Void
