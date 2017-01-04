//
//  CryptoTests.swift
//  kbswift
//
//  Created by Prashant Sinha on 05/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import XCTest


@testable import kbswift

class CryptoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCrypto() {
        let ret = Crypto.scrypt(pswd: "pswd", salt: "salt")
        XCTAssert(ret == 0)
    }
}

