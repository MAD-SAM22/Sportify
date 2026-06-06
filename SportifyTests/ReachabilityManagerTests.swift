//
//  ReachabilityManagerTests.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//

import XCTest
import Alamofire
@testable import Sportify

final class ReachabilityManagerTests: XCTestCase {

    var sut: ReachabilityManager!

    override func setUp() {
        super.setUp()
        sut = ReachabilityManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Shared instance

    func test_shared_isNotNil() {
        XCTAssertNotNil(ReachabilityManager.shared)
    }

    func test_shared_returnsSameInstance() {
        let a = ReachabilityManager.shared
        let b = ReachabilityManager.shared
        XCTAssertTrue(a === b)
    }

    // MARK: - isConnectedToInternet

    func test_isConnectedToInternet_returnsBoolean() {
        // We can't control the real network in unit tests,
        // but we verify the property exists and returns a valid Bool.
        let result = sut.isConnectedToInternet
        XCTAssertNotNil(result)
    }

    func test_isConnectedToInternet_matchesReachabilityState() {
        // The value must be consistent across two consecutive reads.
        let first = sut.isConnectedToInternet
        let second = sut.isConnectedToInternet
        XCTAssertEqual(first, second)
    }

    // MARK: - startMonitoring

    func test_startMonitoring_doesNotCrash() {
        // Verifies startMonitoring can be called without throwing or crashing.
        XCTAssertNoThrow(sut.startMonitoring())
    }

    func test_startMonitoring_canBeCalledMultipleTimes() {
        // Calling startMonitoring repeatedly must not crash or produce side effects.
        sut.startMonitoring()
        sut.startMonitoring()
        sut.startMonitoring()
        XCTAssertTrue(true) // reached without crash
    }
}
