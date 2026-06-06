//
//  TeamInfoCardsViewTests.swift
//  Sportify
//
//  Created by Osama Hosam on 06/06/2026.
//


import XCTest
internal import SkeletonView

@testable import Sportify

final class TeamInfoCardsViewTests: XCTestCase {
    
    private var sut: TeamInfoCardsView!
    
    // Outlets pointers
    private var countryIconLabel: UIImageView!
    private var countryValueLabel: UILabel!
    private var stadiumIconLabel: UIImageView!
    private var stadiumValueLabel: UILabel!
    private var foundedIconLabel: UIImageView!
    private var foundedValueLabel: UILabel!
    
    private var countryCard: UIView!
    private var stadiumCard: UIView!
    private var foundedCard: UIView!
    
    override func setUp() {
        super.setUp()
        sut = TeamInfoCardsView(frame: CGRect(x: 0, y: 0, width: 375, height: 120))
        
        // Initialize programmatic mock components
        countryIconLabel = UIImageView()
        countryValueLabel = UILabel()
        stadiumIconLabel = UIImageView()
        stadiumValueLabel = UILabel()
        foundedIconLabel = UIImageView()
        foundedValueLabel = UILabel()
        
        countryCard = UIView()
        stadiumCard = UIView()
        foundedCard = UIView()
        
        // Link up structural properties manually
        sut.countryIconLabel = countryIconLabel
        sut.countryValueLabel = countryValueLabel
        sut.stadiumIconLabel = stadiumIconLabel
        sut.stadiumValueLabel = stadiumValueLabel
        sut.foundedIconLabel = foundedIconLabel
        sut.foundedValueLabel = foundedValueLabel
        
        sut.countryCard = countryCard
        sut.stadiumCard = stadiumCard
        sut.foundedCard = foundedCard
        
        // Trigger lifecycle layout calculations
        sut.awakeFromNib()
    }
    
    override func tearDown() {
        sut = nil
        countryIconLabel = nil
        countryValueLabel = nil
        stadiumIconLabel = nil
        stadiumValueLabel = nil
        foundedIconLabel = nil
        foundedValueLabel = nil
        countryCard = nil
        stadiumCard = nil
        foundedCard = nil
        super.tearDown()
    }
    
    // MARK: - Loop Iteration & Design Layer Tests
    
    func test_awakeFromNib_configuresAllInformationCardContainers() {
        let cards = [countryCard, stadiumCard, foundedCard]
        
        cards.forEach { card in
            XCTAssertEqual(card?.layer.cornerRadius, 16, "Each sub-card view container layout node requires 16pt corner radius configuration.")
            XCTAssertTrue(card!.layer.masksToBounds, "Every info card node canvas frame boundary clipping layer mask option must enable true.")
            XCTAssertNotNil(card?.backgroundColor, "Fallback color structures must evaluate safely to prevent runtime transparent background layers.")
        }
    }
    
    func test_awakeFromNib_configuresAllDataValueLabels() {
        let valueLabels = [countryValueLabel, stadiumValueLabel, foundedValueLabel]
        
        valueLabels.forEach { label in
            XCTAssertNotNil(label?.textColor, "Styling themes require standard catalog label colors to be bound to text properties.")
            XCTAssertEqual(label?.font, UIFont.boldSystemFont(ofSize: 16), "Text labels should format text with a 16pt bold design variant.")
            XCTAssertEqual(label?.textAlignment, .center, "Value strings inside metrics panels should display centered layout tracking flags.")
            XCTAssertEqual(label?.numberOfLines, 2, "Label component lines property needs to be equal to 2 to protect longer team venue values from truncation.")
        }
    }
    
    func test_awakeFromNib_configuresAllMetricSymbolImageViews() {
        let iconViews = [countryIconLabel, stadiumIconLabel, foundedIconLabel]
        
        iconViews.forEach { iconView in
            XCTAssertNotNil(iconView?.tintColor, "Uniform vector system layout paths expect a solid accent colors context layer tint applied.")
            XCTAssertEqual(iconView?.contentMode, .scaleAspectFit, "Vector images must fit uniformly without geometric aspect ratio distortions.")
        }
    }
    
    // MARK: - SkeletonView Integration Loop Tests
    
    func test_awakeFromNib_setsUpSkeletonFlagsForHierarchicalLayoutElements() {
        XCTAssertTrue(sut.isSkeletonable, "The primary composite parent cards assembly view layout requires programmatic structural skeleton capabilities enabled.")
        
        let subNodes: [UIView?] = [
            countryCard, stadiumCard, foundedCard,
            countryIconLabel, stadiumIconLabel, foundedIconLabel,
            countryValueLabel, stadiumValueLabel, foundedValueLabel
        ]
        
        subNodes.forEach { node in
            XCTAssertTrue(node!.isSkeletonable, "Component layouts should report true to skeleton framework sweeps.")
        }
        
        // Assert label specific structural bounds restrictions
        let labels = [countryValueLabel, stadiumValueLabel, foundedValueLabel]
        labels.forEach { label in
            XCTAssertEqual(label?.skeletonTextNumberOfLines, 1, "Loading skeletons within tight information cards look tidier wrapped inside 1 linear placeholder bar block.")
        }
    }
    
    // MARK: - Data Interface Tests
    
    func test_configure_mapsSuppliedDataStringsToCorrectLabelTargets() {
        // When
        sut.configure(country: "Egypt", stadium: "Cairo International Stadium", founded: "1911")
        
        // Then
        XCTAssertEqual(countryValueLabel.text, "Egypt")
        XCTAssertEqual(stadiumValueLabel.text, "Cairo International Stadium")
        XCTAssertEqual(foundedValueLabel.text, "1911")
    }
}
