//
//  KeybaseStructs.swift
//  kbswift
//
//  Created by Prashant Sinha on 08/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import Foundation

struct KBSigBody {
    var detached: Bool
    let hash_type = 10
    var key: CryptoBuffer
    var payload: CryptoBuffer
    var sig: CryptoBuffer
    let sig_type = 32
}

struct KBSigPacket {
    var body: KBSigBody
    let tag = 514
    let version = 1
}

