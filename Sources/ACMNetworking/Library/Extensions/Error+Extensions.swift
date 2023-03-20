//
//  Error+Extensions.swift
//

import Foundation

extension Error {
    var isConnectivityError: Bool {
        let code = (self as NSError).code

        if code == NSURLErrorTimedOut {
            return true // time-out
        }

        if _domain != NSURLErrorDomain {
            return false // Cannot be a NSURLConnection error
        }

        switch code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
            return true
        default:
            return false
        }
    }
}
