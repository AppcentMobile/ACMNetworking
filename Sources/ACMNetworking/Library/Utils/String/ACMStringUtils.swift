//
//  ACMStringUtils.swift
//

import Foundation

/// ACMStringUtils
///
/// String utility for making string actions easily
public final class ACMStringUtils {
    public init() {}
    func merge(list: [String]) -> String {
        return list.joined(separator: " ")
    }
    var uniqueID: String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomHash = String((0..<6).compactMap { _ in characters.randomElement() })
        return String(format: "%d;%@", timestamp, randomHash)
    }
}
