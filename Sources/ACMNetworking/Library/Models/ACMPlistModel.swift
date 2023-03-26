//
//  ACMPlistModel.swift
//

/// ACMPlistModel
///
/// A struct that holds the plist
struct ACMPlistModel: Codable {
    var baseURL: String
    var timeout: Double
    var isLogEnabled: Bool
}
