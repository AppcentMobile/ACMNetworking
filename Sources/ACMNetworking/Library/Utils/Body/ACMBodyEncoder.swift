//
//  ACMBodyEncoder.swift
//

import Foundation

/// ACMBodyEncoder
///
/// Encoder for body payload
enum ACMBodyEncoder {
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
                if let item = $1.value as? Codable {
                    if let dict = item.dictionary {
                        $0[$1.key] = dict
                    } else if let arrayOfCodable = $1.value as? [Codable] {
                        $0[$1.key] = arrayOfCodable.map { item in
                            if let dict = item.dictionary {
                                return dict
                            } else if let str = item as? String {
                                if let data = str.data(using: .utf8, allowLossyConversion: true),
                                   let list = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
                                {
                                    return list
                                } else {
                                    return [:]
                                }
                            } else {
                                return [:]
                            }
                        }
                    } else {
                        $0[$1.key] = ""
                    }
                } else if let item = $1.value as? Encodable {
                    if let dict = item.dictionary {
                        $0[$1.key] = dict
                    } else if let arrayOfEncodable = $1.value as? [Encodable] {
                        $0[$1.key] = arrayOfEncodable.map { $0.dictionary }
                    } else {
                        $0[$1.key] = ""
                    }
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
             is Encodable:
            return true
        default:
            return false
        }
    }
}
