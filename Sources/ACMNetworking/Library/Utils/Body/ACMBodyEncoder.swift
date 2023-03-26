//
//  ACMBodyEncoder.swift
//

import Foundation

/// ACMBodyEncoder
///
/// Encoder for body payload
final class ACMBodyEncoder {

    /// Encode function
    /// For creating body payload
    ///    - Parameters:
    ///      - list: Body list
    ///    - Returns
    ///      - [String: Any?]
    static func encode(with list: [ACMBodyModel]) -> [String: Any?] {
        return list.reduce(into: [String: Any?]()) {
            $0[$1.key] = $1.value
        }
    }
}
