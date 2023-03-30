//
//  ACMPlistModel.swift
//

/// ACMPlistModel
///
/// A struct that holds the plist
open class ACMPlistModel: Codable {
    var baseURL: String
    var timeout: Double
    var isLogEnabled: Bool

    enum CodingKeys: CodingKey {
        case baseURL
        case timeout
        case isLogEnabled
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseURL, forKey: .baseURL)
        try container.encode(timeout, forKey: .timeout)
        try container.encode(isLogEnabled, forKey: .isLogEnabled)
    }
}
