//
//  ViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 19/05/2026.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    
    let sportsData: [SportsHome] = [
        SportsHome(name: "Basketball", imageName: "basketball_img"),
        SportsHome(name: "Soccer", imageName: "soccer_img"),
        SportsHome(name: "Tennis", imageName: "tennis_img"),
        SportsHome(name: "Football", imageName: "football_img"),
        SportsHome(name: "Swimming", imageName: "swimming_img"),
        SportsHome(name: "Cycling", imageName: "cycling_img")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 12
            layout.minimumLineSpacing = 16
        }
    }

    // MARK: - UICollectionViewDataSource
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return sportsData.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSportsCell", for: indexPath) as! SportsCollectionViewCell
            
            let sport = sportsData[indexPath.item]
            cell.sportLabel.text = sport.name
            cell.sportImageView.image = UIImage(named: sport.imageName)
            
            return cell
        }
        
        // MARK: - UICollectionViewDelegateFlowLayout (Grid Math)
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideInset: CGFloat = 12    // must match insetForSectionAt left/right
        let gap: CGFloat = 12          // gap between the two columns
        let availableWidth = collectionView.frame.width - (sideInset * 2) - gap
        let side = availableWidth / 2
        return CGSize(width: side, height: side * 1.2)
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
    }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 16 // Vertical space between rows
        }
    }
