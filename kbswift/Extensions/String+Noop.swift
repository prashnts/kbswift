//
//  String+Noop.swift
//  kbswift
//
//  Created by Prashant Sinha on 09/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import Foundation

let VALID_HEX = "abcdef0123456789"

extension String {
    /// Obtain chunks of the string.
    func chunks(withLength length: Int) -> Array<String> {
        return stride(from: 0, to: self.characters.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return self[start..<end]
        }
    }

    /// Convert from hexed representation back to Byte Buffer.
    func unhex() -> CryptoBuffer? {
        let convertible = self.lowercased().characters
            .reduce(true) { (prev, c) -> Bool in prev && VALID_HEX.characters.contains(c) }

        guard self.characters.count % 2 == 0 && convertible else {
            return nil
        }
        return self.chunks(withLength: 2).map { UInt8.init($0, radix: 16)! }
    }
}
