//
//  ACMStringUtils.swift
//

/// ACMStringUtils
///
/// String utility for making string actions easily
public final class ACMStringUtils {
    static let shared = ACMStringUtils()

    func merge(list: [String]) -> String {
        return list.joined(separator: " ")
    }
}
