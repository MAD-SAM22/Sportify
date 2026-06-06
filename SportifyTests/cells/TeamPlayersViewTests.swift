//
//  TeamPlayersViewTests.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
@testable import Sportify
internal import SkeletonView
internal import Kingfisher

final class TeamPlayersViewTests: XCTestCase {
    
    private var sut: TeamPlayersView!
    private var titleLabel: UILabel!
    private var scrollView: UIScrollView!
    private var playersStackView: UIStackView!
    
    override func setUp() {
        super.setUp()
        sut = TeamPlayersView(frame: CGRect(x: 0, y: 0, width: 375, height: 150))
        
        titleLabel = UILabel()
        scrollView = UIScrollView()
        playersStackView = UIStackView()
        
        sut.titleLabel = titleLabel
        sut.scrollView = scrollView
        sut.playersStackView = playersStackView
        
        sut.awakeFromNib()
    }
    
    override func tearDown() {
        sut = nil
        titleLabel = nil
        scrollView = nil
        playersStackView = nil
        super.tearDown()
    }
    
    // MARK: - Initial Setup Tests
    
    func test_awakeFromNib_configuresDefaultStyles() {
        XCTAssertEqual(titleLabel.text, "Players")
        XCTAssertEqual(titleLabel.font, UIFont.boldSystemFont(ofSize: 18))
        XCTAssertNotNil(titleLabel.textColor)
        XCTAssertFalse(scrollView.showsHorizontalScrollIndicator, "The horizontal scroll indicator should be hidden for clean carousel tracking.")
    }
    
    func test_setupSkeleton_enablesSkeletonFlags() {
        XCTAssertTrue(playersStackView.isSkeletonable, "The content stack view must allow skeleton framework layer sweeps.")
    }
    
    // MARK: - Standard View Population Tests
    
    func test_configure_buildsPlayerSubviewsAndClearsPreviousEntries() {
        // Given
        let initialPlayers = [("Player 1", UIImage())]
        sut.configure(players: initialPlayers)
        XCTAssertEqual(playersStackView.arrangedSubviews.count, 1)
        
        let targetPlayers = [
            ("Mo Salah", UIImage()),
            ("Virgil", nil)
        ]
        
        // When
        sut.configure(players: targetPlayers)
        
        // Then: Ensure previous entries were wiped out and rebuilt cleanly
        XCTAssertEqual(playersStackView.arrangedSubviews.count, 2)
        
        let firstContainer = playersStackView.arrangedSubviews[0]
        let labelNode = firstContainer.subviews.first { $0 is UILabel } as? UILabel
        let imageNode = firstContainer.subviews.first { $0 is UIImageView } as? UIImageView
        
        XCTAssertEqual(labelNode?.text, "Mo Salah")
        XCTAssertEqual(labelNode?.font, UIFont.systemFont(ofSize: 11))
        XCTAssertEqual(labelNode?.numberOfLines, 2)
        XCTAssertEqual(imageNode?.layer.cornerRadius, 25, "Image corner radius must be 25 to match 50pt width for a circular presentation.")
    }
    
    // MARK: - Skeleton Shimmer Generation Flow Tests
    
    func test_setupDummySkeletonViews_populatesFiveLoadingPlaceholders() {
        // When
        sut.setupDummySkeletonViews()
        
        // Then
        XCTAssertEqual(playersStackView.arrangedSubviews.count, 5, "Skeleton state should display exactly 5 dummy items to simulate a full row pattern.")
        
        let sampleSkeletonContainer = playersStackView.arrangedSubviews[0]
        XCTAssertTrue(sampleSkeletonContainer.isSkeletonable)
        
        let labelNode = sampleSkeletonContainer.subviews.first { $0 is UILabel } as? UILabel
        let imageNode = sampleSkeletonContainer.subviews.first { $0 is UIImageView } as? UIImageView
        
        XCTAssertTrue(labelNode!.isSkeletonable)
        XCTAssertEqual(labelNode?.text, "Loading")
        XCTAssertEqual(labelNode?.skeletonTextNumberOfLines, 1, "Labels should fall back to single-line skeletal bounding bars.")
        XCTAssertTrue(imageNode!.isSkeletonable)
    }
    
    // MARK: - Kingfisher URL Back-filling Tests
    
    func test_configureWithURLs_mapsValidStringsToExistingImageViews() {
        // Given: Set up 3 dummy structural cards first
        sut.setupDummySkeletonViews() 
        let imageURLs = [
            "https://media.api-sports.io/players/1.png",
            "https://media.api-sports.io/players/2.png"
        ]
        
        // When: Back-filling live profile URLs into existing slots
        sut.configureWithURLs(imageURLs)
        
        // Then: Only index 0 and 1 should hook into Kingfisher setups
        let container0 = playersStackView.arrangedSubviews[0]
        let imageNode0 = container0.subviews.first { $0 is UIImageView } as? UIImageView
        XCTAssertNotNil(imageNode0?.kf)
        
        // Index 2 had no matching URL token in our mock array parameter input
        let container2 = playersStackView.arrangedSubviews[2]
        let imageNode2 = container2.subviews.first { $0 is UIImageView } as? UIImageView
        XCTAssertEqual(imageNode2?.image, UIImage(systemName: "person.circle.fill"), "Unpopulated skeleton assets must fall back onto static symbol templates.")
    }
}
