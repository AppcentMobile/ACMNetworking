//
//  ACMHeadersEncoder.swift
//

import Foundation

/// ACMHeadersEncoder
///
/// Encoder for headers
final class ACMHeadersEncoder {

    /// Encode function
    /// For creating headers
    ///    - Parameters:
    ///      - list: Header list
    ///    - Returns
    ///      - NSMutableDictionary
    static func encode(with list: [ACMHeaderModel]) -> NSMutableDictionary {
        return list.reduce(into: NSMutableDictionary()) {
            $0[$1.field] = $1.value
        }
    }
}
