//
//  Crypto.swift
//  kbswift
//
//  Created by Prashant Sinha on 05/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import Foundation
import Scrypt

let BUFFER_LEN = 256


class Crypto {
    public static func scrypt(pswd: String, salt: String) -> Int32 {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: BUFFER_LEN)
        
        let ret = Scrypt.libscrypt_scrypt(pswd, pswd.characters.count, salt, salt.characters.count, 2 << 15, 8, 1, buffer, BUFFER_LEN)
        
        if ret == 0 {
        }
        return ret
    }
}
