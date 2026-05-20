//
//  LeaguesViewController.swift
//  Sportify
//
//  Created by Osama Hosam on 20/05/2026.
//

import UIKit

class LeaguesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    

    
    var selectedSport : SportsHome?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Dark background
            view.backgroundColor = UIColor(red: 0.08, green: 0.10, blue: 0.18, alpha: 1)
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none  // remove lines between cells

            // Row height
            tableView.rowHeight = 80

            // Nav bar
            title = "Leagues"
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.08, green: 0.10, blue: 0.18, alpha: 1)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                              .font: UIFont.boldSystemFont(ofSize: 20)]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.tintColor = .white
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesCell", for: indexPath) as! LeaguesTableViewCell
            
//            let currentProduct = products[indexPath.row]
            
        cell.leagueName.text = "English league"
        cell.leagueImage.image = UIImage(named: "football_img")


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // cell pressed
//        let selectedProduct = products[indexPath.row]
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
//            
//            detailsVC.product = selectedProduct
//            
//            self.navigationController?.pushViewController(detailsVC, animated: true)
//        }
        
        
    }
    
}
