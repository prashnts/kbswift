//
//  Crypto.swift
//  kbswift
//
//  Created by Prashant Sinha on 05/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import Foundation
import Scrypt
import Ed25519

let MODIFIER_BOUND: UInt32 = 2 << 30
let BUFFER_LEN_MAX: Int = ((2 << 32) - 1) * 32

let SEED_LEN = 32,
    PUBKEY_LEN = 32,
    PRIKEY_LEN = 64,
    SIGNATURE_LEN = 64

enum CryptoError: Error {
    case invalidParam
    case seedLengthMismatch
}

typealias CryptoBuffer = Array<UInt8>
typealias CryptoKeyPair = (public_key: CryptoBuffer, private_key: CryptoBuffer)

typealias _CryptoBufferPtr = UnsafeMutablePointer<UInt8>

class Crypto {
    /// Scrypt is a password-based key derivation function.
    /// This method wraps scrypt implementation in libscrypt.
    /// 
    /// - Parameters
    ///     - pswd: Password
    ///     - salt: Salt
    ///     - N: CPU AND RAM cost (first modifier)
    ///     - r: RAM Cost
    ///     - p: CPU cost (parallelisation)
    ///     - bufflen: Intended length of output buffer.
    /// - Returns: Key
    public static func scrypt(pswd: String, salt: String, N: UInt64, r: UInt32, p: UInt32, bufflen: Int) throws -> Array<UInt8>? {
        let sane = N >> 2 > 0 && r * p < MODIFIER_BOUND && bufflen < BUFFER_LEN_MAX

        if !sane {
            throw CryptoError.invalidParam
        }
        
        let bufferptr = UnsafeMutablePointer<UInt8>.allocate(capacity: bufflen)
        let exitcode = Scrypt.libscrypt_scrypt(
            pswd, pswd.characters.count,
            salt, salt.characters.count,
            N, r, p, bufferptr, bufflen)

        let key = Array(UnsafeBufferPointer(start: bufferptr, count: bufflen))
        
        // Yay for manual memory management!
        bufferptr.deallocate(capacity: bufflen)
        if exitcode == -1 {
            return nil
        }
        return key
    }
}
