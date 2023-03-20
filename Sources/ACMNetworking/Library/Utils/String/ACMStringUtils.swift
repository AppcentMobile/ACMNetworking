//
//  ACMStringUtils.swift
//

public final class ACMStringUtils {
    static let shared = ACMStringUtils()

    func merge(list: [String]) -> String {
        return list.joined(separator: " ")
    }
}
