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
            if ACMBodyEncoder.isNativeVariableType($1.value) {
                $0[$1.key] = $1.value
            } else if ACMBodyEncoder.isVariableCodable($1.value) {
                if let codable = $1.value as? Encodable {
                    $0[$1.key] = codable.dictionary
                } else {
                    $0[$1.key] = ""
                }
            } else if ACMBodyEncoder.isVariableCodableArray($1.value) {
                if let codableArray = $1.value as? [Encodable] {
                    $0[$1.key] = codableArray.map { $0.dictionary }
                } else {
                    $0[$1.key] = ""
                }
            } else {
                $0[$1.key] = ""
            }
        }
    }

    private static func isNativeVariableType<T>(_ value: T) -> Bool {
        switch value {
        case is Int, is UInt, is Float, is Double, is Bool, is String:
            return true
        default:
            return false
        }
    }

    private static func isVariableCodable<T>(_ value: T) -> Bool {
        switch value {
        case is Codable,
             is Encodable,
             is Decodable:
            return true
        default:
            return false
        }
    }

    private static func isVariableCodableArray<T>(_ value: T) -> Bool {
        switch value {
        case is [Codable],
             is [Encodable],
             is [Decodable]:
            return true
        default:
            return false
        }
    }
}
