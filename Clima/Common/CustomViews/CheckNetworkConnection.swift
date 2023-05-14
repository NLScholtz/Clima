//
//  CheckNetworkConnection.swift
//  Clima
//
//  Created by Nicole Scholtz on 2023/05/13.
//

import Foundation
import SystemConfiguration

public class CheckNetworkConnection {

    public static func isConnectedToNetwork() -> Bool {
           
           var noAddress = sockaddr_in()
           noAddress.sin_len = UInt8(MemoryLayout.size(ofValue: noAddress))
           noAddress.sin_family = sa_family_t(AF_INET)
           guard let defaultRouteReachability = withUnsafePointer(to: &noAddress, {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                   SCNetworkReachabilityCreateWithAddress(nil, $0)
               }
           }) else {
               return false
           }
        
           var flags = SCNetworkReachabilityFlags()
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
               return false
           }
        
           let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
           let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
           return (isReachable && !needsConnection)
       }
}
