//
//  ExtensionTest.swift
//  kbswift
//
//  Created by Prashant Sinha on 09/01/17.
//  Copyright © 2017 Noop. All rights reserved.
//

import XCTest


@testable import kbswift

class StringExtension: XCTestCase {
    func testChunk() {
        let candidate = "Super Trouper!"
        let known: Array<String> = ["Su", "pe", "r ", "Tr", "ou", "pe", "r!"]
        XCTAssert(known == candidate.chunks(withLength: 2))
    }

    func testUnhexGood() {
        let candidate = "ffcc11"
        let known: CryptoBuffer = [255, 204, 17]
        XCTAssert(candidate.unhex()! == known)
    }

    func testUnhexBad() {
        let candidate = "ISHALLFAIL"
        XCTAssert(candidate.unhex() == nil)
    }
}
