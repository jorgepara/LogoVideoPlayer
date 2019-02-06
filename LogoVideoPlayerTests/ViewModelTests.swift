//
//  ViewModelTests.swift
//  LogoVideoPlayerTests
//
//  Created by Para Molina, Jorge (Cognizant) on 2/5/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import XCTest
import ARKit

@testable import LogoVideoPlayer


class ViewModelTests: XCTestCase {

    func testConfiguration() {
        let viewModel = ViewModel()
        let configuration = viewModel.configuration as? ARWorldTrackingConfiguration
        XCTAssertNotNil(configuration)
        XCTAssertGreaterThan(configuration?.detectionImages.count ?? 0, 0)
    }

}
