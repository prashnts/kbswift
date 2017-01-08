//
//  Array+UInt8+Hex.swift
//  kbswift
//
//  Created by Prashant Sinha on 09/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element == UInt8 {
    /// Returns a hex string of a Bytearrayy (Array<UInt8>)
    var hex: String {
        let hex = self.map {el in el.hex}
        return hex.joined()
    }
}
