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

public enum CryptoError: Error {
    case invalidParam
    case seedLengthMismatch
}

public typealias CryptoBuffer = Array<UInt8>
public typealias CryptoKeyPair = (public_key: CryptoBuffer, private_key: CryptoBuffer)

typealias _CryptoBufferPtr = UnsafeMutablePointer<UInt8>

extension Array where Element: UInt8 {
    var base64: String {
        return Data(self).base64EncodedString()
    }
}

public class Crypto {
    /**
     Scrypt is a password-based key derivation function.
     This method wraps scrypt implementation in libscrypt.
     
     - Parameters
        - pswd: Password
        - salt: Salt
        - N: CPU AND RAM cost (first modifier)
        - r: RAM Cost
        - p: CPU cost (parallelisation)
        - bufflen: Intended length of output buffer.
     - Returns: Key
     */
    public static func scrypt(pswd: String, salt: String, N: UInt64, r: UInt32, p: UInt32, bufflen: Int) throws -> CryptoBuffer? {
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


public class EdDSA {
    /**
     Returns a 32 Byte Random Seed for Key Generation.
     */
    public static func createSeed() -> CryptoBuffer {
        let seed_buffer = _CryptoBufferPtr.allocate(capacity: SEED_LEN)

        let _ = Ed25519.ed25519_create_seed(seed_buffer)

        let seed = Array(UnsafeBufferPointer(start: seed_buffer, count: SEED_LEN))
        seed_buffer.deallocate(capacity: SEED_LEN)
        return seed
    }

    /**
     Returns a new key pair from the given seed.
     
     - Parameters:
        - seed: A 32 Byte CryptoBuffer
     - Returns: A Public and Private KeyPair
     */
    public static func createKeypair(seed: CryptoBuffer) throws -> CryptoKeyPair {
        if seed.count != SEED_LEN {
            throw CryptoError.seedLengthMismatch
        }
        
        let pub_buffer  = _CryptoBufferPtr.allocate(capacity: PUBKEY_LEN),
            priv_buffer = _CryptoBufferPtr.allocate(capacity: PRIKEY_LEN),
            seed_buffer = _CryptoBufferPtr(mutating: seed)

        Ed25519.ed25519_create_keypair(pub_buffer, priv_buffer, seed_buffer)
        
        let pub_key = Array(UnsafeBufferPointer(start: pub_buffer, count: PUBKEY_LEN)),
            private_key = Array(UnsafeBufferPointer(start: priv_buffer, count: PRIKEY_LEN))

        pub_buffer.deallocate(capacity: PUBKEY_LEN)
        priv_buffer.deallocate(capacity: PRIKEY_LEN)

        return (pub_key, private_key)
    }

    /**
     Returns a signature of the given message with the given key pair.
     
     - Parameters:
        - message: Message to be signed
        - keypair: A Public, Private KeyPair
     - Returns: A 64 Byte Signature
     */
    public static func sign(message: String, keypair: CryptoKeyPair) -> CryptoBuffer {
        let sig_buffer = _CryptoBufferPtr.allocate(capacity: SIGNATURE_LEN)
        Ed25519.ed25519_sign(sig_buffer, message, message.characters.count, keypair.public_key, keypair.private_key)
        
        let signature = Array(UnsafeBufferPointer(start: sig_buffer, count: SIGNATURE_LEN))
        sig_buffer.deallocate(capacity: SIGNATURE_LEN)
        return signature
    }

    /**
     Verifies the signature on the given message using the given Public Key.
     */
    public static func verify(signature: CryptoBuffer, message: String, public_key: CryptoBuffer) -> Bool {
        let match = Ed25519.ed25519_verify(signature, message, message.characters.count, public_key)
        return match == 1
    }
}

