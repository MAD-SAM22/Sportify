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

    private let reachability = NetworkReachabilityManager()

    init() {}

    var isConnectedToInternet: Bool {
        return reachability?.isReachable ?? false
    }

    func startMonitoring() {
        reachability?.startListening { status in
            print("Network Status Changed: \(status)")
        }
    }
}
