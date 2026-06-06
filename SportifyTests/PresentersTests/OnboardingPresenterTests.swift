//
//  OnboardingViewSpy.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
@testable import Sportify

// MARK: - Mocks & Spies
final class OnboardingViewSpy: OnboardingViewProtocol {
    var isReloadDataCalled = false
    var updatedPageIndicatorIndex: Int?
    var isNavigateToMainAppCalled = false
    
    func reloadData() {
        isReloadDataCalled = true
    }
    
    func updatePageIndicator(to index: Int) {
        updatedPageIndicatorIndex = index
    }
    
    func navigateToMainApp() {
        isNavigateToMainAppCalled = true
    }
}

// MARK: - Test Suite
final class OnboardingPresenterTests: XCTestCase {
    
    private var sut: OnboardingPresenter! // System Under Test
    private var viewSpy: OnboardingViewSpy!
    
    override func setUp() {
        super.setUp()
        viewSpy = OnboardingViewSpy()
        sut = OnboardingPresenter(view: viewSpy)
    }
    
    override func tearDown() {
        sut = nil
        viewSpy = nil
        super.tearDown()
    }
    
    // MARK: - Lifecycle Tests
    
    func test_viewDidLoad_setsUpSlidesAndReloadsData() {
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.slides.count, 3, "Slides array should be populated with exactly 3 items.")
        XCTAssertTrue(viewSpy.isReloadDataCalled, "View's reloadData() should be called on viewDidLoad.")
        
        // Verifying slide contents
        XCTAssertEqual(sut.slides[0].imageName, "onboarding1")
        XCTAssertEqual(sut.slides[1].imageName, "onboarding2")
        XCTAssertEqual(sut.slides[2].imageName, "onboarding3")
    }
    
    // MARK: - Next Button Clicked Tests
    
    func test_nextButtonClicked_whenNotLastSlide_updatesPageIndicator() {
        // Given
        sut.viewDidLoad() // Populates the slides
        let currentFirstIndex = 0
        
        // When
        sut.nextButtonClicked(currentIndex: currentFirstIndex)
        
        // Then
        XCTAssertEqual(viewSpy.updatedPageIndicatorIndex, 1, "Should tell the view to move to index 1 from index 0.")
        XCTAssertFalse(viewSpy.isNavigateToMainAppCalled, "Should not navigate to main app yet.")
    }
    
    func test_nextButtonClicked_whenOnLastSlide_navigatesToMainApp() {
        // Given
        sut.viewDidLoad()
        let lastIndex = sut.slides.count - 1 // Index 2
        
        // When
        sut.nextButtonClicked(currentIndex: lastIndex)
        
        // Then
        XCTAssertTrue(viewSpy.isNavigateToMainAppCalled, "Should trigger main app navigation when clicking next on the final slide.")
        XCTAssertNil(viewSpy.updatedPageIndicatorIndex, "Page indicator shouldn't update past the total slide count.")
    }
    
    // MARK: - Skip Button Clicked Tests
    
    func test_skipButtonClicked_navigatesToMainApp() {
        // Given (Skipping works regardless of current index state)
        sut.viewDidLoad()
        
        // When
        sut.skipButtonClicked()
        
        // Then
        XCTAssertTrue(viewSpy.isNavigateToMainAppCalled, "Should immediately transition to the main app flow upon skipping.")
    }
}