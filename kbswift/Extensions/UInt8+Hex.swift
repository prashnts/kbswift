//
//  UInt8+Hex.swift
//  kbswift
//
//  Created by Prashant Sinha on 09/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import Foundation

extension UInt8 {
    /// Returns a hex representation of the digit.
    var hex: String {
        return String(format: "%02x", self)
    }
}
