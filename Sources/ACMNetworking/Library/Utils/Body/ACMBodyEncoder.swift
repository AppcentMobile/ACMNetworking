//
//  ACMBodyEncoder.swift
//

import Foundation

final class ACMBodyEncoder {
    static func encode(with list: [ACMBodyModel]) -> [String: Any?] {
        return list.reduce(into: [String: Any?]()) {
            $0[$1.key] = $1.value
        }
    }
}
