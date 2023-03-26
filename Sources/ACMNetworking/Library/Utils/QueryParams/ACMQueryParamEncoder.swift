//
//  ACMQueryParamEncoder.swift
//

import Foundation

/// ACMQueryParamEncoder
///
/// Encoder for query parameters
final class ACMQueryParamEncoder {
    /// Static function for encode
    /// Creates queryitem list with given query model list
    ///    - Parameters:
    ///      - list: Query model list
    ///    - Returns
    ///      - [URLQueryItem]
    static func encode(with list: [ACMQueryModel]) -> [URLQueryItem] {
        return list.map { URLQueryItem(name: $0.name, value: $0.value) }
    }
}
