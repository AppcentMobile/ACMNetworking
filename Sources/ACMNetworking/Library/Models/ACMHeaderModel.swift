//
//  ACMHeaderModel.swift
//

/// ACMHeaderModel
///
/// A struct that holds the header
public struct ACMHeaderModel {
    var field: String
    var value: String

    /// Public Init function
    /// For creating header
    ///    - Parameters:
    ///      - field: Header key
    ///      - value: Header value
    ///    - Returns
    ///      - Void
    public init(field: String, value: String) {
        self.field = field
        self.value = value
    }
}
