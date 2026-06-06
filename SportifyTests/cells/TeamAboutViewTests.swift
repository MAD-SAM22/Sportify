//
//  TeamAboutViewTests.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
@testable import Sportify

final class TeamAboutViewTests: XCTestCase {
    
    private var sut: TeamAboutView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var containerCard: UIView!
    
    override func setUp() {
        super.setUp()
        // 1. Create a programmatic instance of the view
        sut = TeamAboutView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
        
        // 2. Initialize and hook up the mock outlets since we aren't loading from a live .xib file in tests
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        containerCard = UIView()
        
        sut.titleLabel = titleLabel
        sut.descriptionLabel = descriptionLabel
        sut.containerCard = containerCard
        
        // 3. Manually trigger the lifecycle setup method
        sut.awakeFromNib()
    }
    
    override func tearDown() {
        sut = nil
        titleLabel = nil
        descriptionLabel = nil
        containerCard = nil
        super.tearDown()
    }
    
    // MARK: - UI Configuration Tests
    
    func test_awakeFromNib_configuresContainerCardStyling() {
        XCTAssertEqual(containerCard.layer.cornerRadius, 16, "The container card corner radius should be set to 16 points.")
        XCTAssertTrue(containerCard.layer.masksToBounds, "The container card should mask its bounds to clip subviews correctly.")
        XCTAssertNotNil(containerCard.backgroundColor, "The container card background color must not be nil.")
    }
    
    func test_awakeFromNib_configuresTitleLabelDefaultStyling() {
        XCTAssertNotNil(titleLabel.textColor, "Title label should have a distinct font color assigned.")
        XCTAssertEqual(titleLabel.font, UIFont.boldSystemFont(ofSize: 18), "The title label text size should be 18pt bold.")
    }
    
    func test_awakeFromNib_configuresDescriptionLabelDefaultStyling() {
        XCTAssertNotNil(descriptionLabel.textColor, "Description label text color must be assigned from style assets.")
        XCTAssertEqual(descriptionLabel.font, UIFont.systemFont(ofSize: 14), "The description label should use a regular 14pt system font size.")
        XCTAssertEqual(descriptionLabel.numberOfLines, 0, "Description label must support infinite lines (0) to handle arbitrary team logs.")
    }
    
    // MARK: - Logic Interaction Tests
    
    func test_configure_updatesDescriptionLabelText() {
        // Given
        let expectedDescription = "Sportify FC was founded in 2026 to push regional athletic potential."
        
        // When
        sut.configure(description: expectedDescription)
        
        // Then
        XCTAssertEqual(descriptionLabel.text, expectedDescription, "Calling configure should map the provided string directly to the description layout label text.")
    }
    
    // MARK: - Environment Change Tests
    
    func test_traitCollectionDidChange_reappliesUISettings() {
        // Given
        titleLabel.text = "Cleared Text Value"
        
        // When: Simulating a system theme change (e.g. Dark Mode toggle)
        sut.traitCollectionDidChange(nil)
        
        // Then: Ensure setupUI runs again and restores localized default layout text
        XCTAssertNotEqual(titleLabel.text, "Cleared Text Value", "The layout properties should reset when interface traits change.")
    }
}