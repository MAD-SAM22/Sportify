import Alamofire
//
//  ReachabilityManager.swift
//  Sportify
//
//  Created by Mina_Wagdy on 01/06/2026.
//
import UIKit

class ReachabilityManager {

    static let shared = ReachabilityManager()

    // Alamofire's reachability manager
    private let reachability = NetworkReachabilityManager()

    init() {}

    // A simple computed property we can check anywhere
    var isConnectedToInternet: Bool {
        return reachability?.isReachable ?? false
    }

    // Optional: Call this in AppDelegate didFinishLaunchingWithOptions if you want to listen to live changes
    func startMonitoring() {
        reachability?.startListening { status in
            print("Network Status Changed: \(status)")
        }
    }
}
