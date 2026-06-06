//
//  TeamHeaderViewTests.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
@testable import Sportify
internal import SkeletonView
internal import Kingfisher

final class TeamHeaderViewTests: XCTestCase {
    
    private var sut: TeamHeaderView!
    private var bannerImageView: UIImageView!
    private var teamLogoImageView: UIImageView!
    private var teamNameLabel: UILabel!
    
    override func setUp() {
        super.setUp()
        sut = TeamHeaderView(frame: CGRect(x: 0, y: 0, width: 375, height: 250))
        
        // Connect programmatic mock outlets
        bannerImageView = UIImageView()
        teamLogoImageView = UIImageView()
        teamNameLabel = UILabel()
        
        sut.bannerImageView = bannerImageView
        sut.teamLogoImageView = teamLogoImageView
        sut.teamNameLabel = teamNameLabel
        
        // Trigger initialization lifecycle code
        sut.awakeFromNib()
    }
    
    override func tearDown() {
        sut = nil
        bannerImageView = nil
        teamLogoImageView = nil
        teamNameLabel = nil
        super.tearDown()
    }
    
    // MARK: - UI Styling & Layout Tests
    
    func test_awakeFromNib_configuresBannerImageViewStyling() {
        XCTAssertEqual(bannerImageView.contentMode, .scaleAspectFill)
        XCTAssertTrue(bannerImageView.clipsToBounds)
        XCTAssertEqual(bannerImageView.layer.cornerRadius, 16)
    }
    
    func test_awakeFromNib_configuresTeamLogoImageViewStyling() {
        XCTAssertEqual(teamLogoImageView.layer.cornerRadius, 30)
        XCTAssertTrue(teamLogoImageView.clipsToBounds)
        XCTAssertEqual(teamLogoImageView.layer.borderWidth, 2)
        XCTAssertNotNil(teamLogoImageView.layer.borderColor, "Logo border color layer context must be explicitly mapped.")
    }
    
    func test_awakeFromNib_configuresTeamNameLabelStyling() {
        XCTAssertNotNil(teamNameLabel.textColor)
        XCTAssertEqual(teamNameLabel.font, UIFont.boldSystemFont(ofSize: 28))
        XCTAssertEqual(teamNameLabel.textAlignment, .center)
    }
    
    // MARK: - SkeletonView Protocol Integration Tests
    
    func test_awakeFromNib_setsUpSkeletonViewCapabilities() {
        XCTAssertTrue(sut.isSkeletonable, "The primary parent view container must be skeletonable.")
        XCTAssertTrue(bannerImageView.isSkeletonable, "Banner components require skeletonable configurations enabled.")
        XCTAssertTrue(teamLogoImageView.isSkeletonable, "Logo layout nodes must support skeleton layouts.")
        XCTAssertTrue(teamNameLabel.isSkeletonable, "Text labels require skeleton capabilities.")
        XCTAssertEqual(teamNameLabel.skeletonTextNumberOfLines, 1, "Skeleton bounds should constrain mock text lines down to 1.")
    }
    
    // MARK: - Configuration & Asset Injection Tests
    
    func test_configure_setsLabelsAndBannerFallbackImage() {
        // When: Passing nil for images to verify assets fallback defaults
        sut.configure(teamName: "Real Madrid", bannerImage: nil, logoURL: nil)
        
        // Then
        XCTAssertEqual(teamNameLabel.text, "Real Madrid")
        XCTAssertEqual(bannerImageView.image, UIImage(named: "team_detail_bg"), "Should display the placeholder banner if no image is passed.")
    }
    
    func test_configure_withInvalidOrNilLogoURL_setsSystemFallbackPlaceholderImage() {
        // When: Passing an invalid text format or a explicit nil reference string 
        sut.configure(teamName: "Arsenal", bannerImage: nil, logoURL: nil)
        
        // Then
        let expectedPlaceholder = UIImage(systemName: "shield.fill")
        XCTAssertEqual(teamLogoImageView.image, expectedPlaceholder, "Should display the shield SF symbol fallback design.")
    }
    
    @MainActor func test_configure_withValidURLStrings_setsKingfisherIndicatorType() {
        // Given
        let validLogoURL = "https://media.api-sports.io/football/teams/33.png"
        
        // When
        sut.configure(teamName: "Manchester United", bannerImage: nil, logoURL: validLogoURL)
        
        // Then
        switch teamLogoImageView.kf.indicatorType {
        case .activity:
            // Test passes successfully
            break
        default:
            XCTFail("Expected Kingfisher indicator type to be .activity, but found a different type.")
        }
    }
}
