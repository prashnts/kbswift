//
//  NSDate+Noop.swift
//  kbswift
//
//  Created by Prashant Sinha on 09/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import Foundation

extension NSDate {
    /// Obtain a UTC timestamp
    var utcTimeStamp: Int {
        return Int(self.timeIntervalSince1970)
    }
}
