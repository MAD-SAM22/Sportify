//
//  TeamLineupViewTests.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
internal import SkeletonView

@testable import Sportify

final class TeamLineupViewTests: XCTestCase {
    
    private var sut: TeamLineupView!
    private var titleLabel: UILabel!
    private var pitchView: UIView!
    private var stackView: UIStackView!
    
    override func setUp() {
        super.setUp()
        sut = TeamLineupView(frame: CGRect(x: 0, y: 0, width: 375, height: 400))
        
        titleLabel = UILabel()
        pitchView = UIView()
        stackView = UIStackView()
        
        sut.titleLabel = titleLabel
        sut.pitchView = pitchView
        sut.stackView = stackView
        
        sut.awakeFromNib()
    }
    
    override func tearDown() {
        sut = nil
        titleLabel = nil
        pitchView = nil
        stackView = nil
        super.tearDown()
    }
    
    // MARK: - Initial UI Setup Tests
    
    func test_awakeFromNib_configuresDefaultStaticProperties() {
        XCTAssertEqual(titleLabel.text, "Team Lineup")
        XCTAssertEqual(titleLabel.font, UIFont.boldSystemFont(ofSize: 18))
        
        XCTAssertEqual(pitchView.layer.cornerRadius, 16)
        XCTAssertTrue(pitchView.layer.masksToBounds)
    }
    
    func test_awakeFromNib_registersSkeletonableComponents() {
        XCTAssertTrue(sut.isSkeletonable)
        XCTAssertTrue(pitchView.isSkeletonable)
    }
    
    // MARK: - Dynamic Configuration & Hierarchy Tests
    
    func test_configure_rebuildsStackViewHierarchyFromData() {
        // Given: A mock formation matrix representing a 1-2 tactical structure
        let formation: [[(name: String, imageURL: String?)]] = [
            [("Alisson", "url_gk")],                // Row 1 (1 player)
            [("Van Dijk", nil), ("Salah", "url_f")] // Row 2 (2 players)
        ]
        
        // When
        sut.configure(formation: formation)
        
        // Then: Verify row stack views
        XCTAssertEqual(stackView.arrangedSubviews.count, 2, "StackView should contain exactly 2 horizontal player row containers.")
        
        guard let row1Stack = stackView.arrangedSubviews[0] as? UIStackView,
              let row2Stack = stackView.arrangedSubviews[1] as? UIStackView else {
            XCTFail("Arranged subview nodes must typecast down to horizontal row UIStackViews successfully.")
            return
        }
        
        // Verify Row 1 properties and spacing
        XCTAssertEqual(row1Stack.axis, .horizontal)
        XCTAssertEqual(row1Stack.distribution, .equalSpacing)
        XCTAssertEqual(row1Stack.alignment, .center)
        XCTAssertEqual(row1Stack.arrangedSubviews.count, 1)
        
        // Verify Row 2 items size
        XCTAssertEqual(row2Stack.arrangedSubviews.count, 2)
    }
    
    func test_configure_removesPreviousViewsOnSubsequentCalls() {
        // Given: Explicitly type the formation to avoid the 'nil' type inference error
        let initialFormation: [[(name: String, imageURL: String?)]] = [
            [("Player 1", nil)]
        ]
        sut.configure(formation: initialFormation)
        XCTAssertEqual(stackView.arrangedSubviews.count, 1)
        
        // When: Configuring with a completely fresh matrix dataset
        let newFormation: [[(name: String, imageURL: String?)]] = [
            [("New Player 1", nil), ("New Player 2", nil)],
            [("New Player 3", nil)]
        ]
        sut.configure(formation: newFormation)
        
        // Then: Old layout nodes must completely clear out instead of stacking up infinitely
        XCTAssertEqual(stackView.arrangedSubviews.count, 2)
    }
    
    // MARK: - Programmatic Subview Factory Tests
    
    func test_createPlayerDot_configuresInternalSubviewsCorrectly() {
        // Given
        let testName = "Mo Salah"
        let testImage = "" // Empty string should trigger fallback logic block
        let dummyMatrix = [[(name: testName, imageURL: testImage)]]
        
        // When
        sut.configure(formation: dummyMatrix)
        
        // Extract the programmatic subview containers out from the live tree hierarchies
        let firstRow = stackView.arrangedSubviews[0] as! UIStackView
        let playerContainer = firstRow.arrangedSubviews[0]
        
        // Check structural auto layout constraints flag overrides
        XCTAssertFalse(playerContainer.translatesAutoresizingMaskIntoConstraints)
        
        // Find internal subview instances
        let labelNode = playerContainer.subviews.first { $0 is UILabel } as? UILabel
        let imageNode = playerContainer.subviews.first { $0 is UIImageView } as? UIImageView
        
        // Verify text label element parameters setup
        XCTAssertNotNil(labelNode)
        XCTAssertEqual(labelNode?.text, testName)
        XCTAssertEqual(labelNode?.font, UIFont.systemFont(ofSize: 9))
        XCTAssertEqual(labelNode?.textAlignment, .center)
        XCTAssertEqual(labelNode?.numberOfLines, 2)
        XCTAssertTrue(labelNode!.layer.masksToBounds)
        
        // Verify background image aspect metrics and boundary clip curves
        XCTAssertNotNil(imageNode)
        XCTAssertEqual(imageNode?.layer.cornerRadius, 20)
        XCTAssertTrue(imageNode!.clipsToBounds)
        XCTAssertEqual(imageNode?.contentMode, .scaleAspectFill)
        
        // Empty image string path verification fallback asset validation
        XCTAssertEqual(imageNode?.image, UIImage(systemName: "person.circle.fill"))
    }
}
