//
//  LogoVideoPlayerTests.swift
//  LogoVideoPlayerTests
//
//  Created by Para Molina, Jorge on 2/5/19.
//  Copyright © 2019 Para Molina, Jorge. All rights reserved.
//

import XCTest
import ARKit
@testable import LogoVideoPlayer

class LogoVideoPlayerTests: XCTestCase {

    func testConfiguration() {
        let viewModel = ViewModel()
        let configuration = viewModel.configuration as? ARWorldTrackingConfiguration
        XCTAssertNotNil(configuration)
        XCTAssertGreaterThan(configuration?.detectionImages.count ?? 0, 0)
    }

    func testInstitutionFactory() {
        XCTAssertNotNil(Institution.make(forImageName: "gf"))
        XCTAssertNotNil(Institution.make(forImageName: "ubu"))
        XCTAssertNil(Institution.make(forImageName: "unknown"))
    }

}
