//
//  ACMHeaderModel.swift
//

/// ACMHeaderModel
///
/// A struct that holds the header
public struct ACMHeaderModel {
    var field: String
    var value: String
    var type: ACMEncryptType

    /// Public Init function
    /// For creating header
    ///    - Parameters:
    ///      - field: Header key
    ///      - value: Header value
    ///    - Returns
    ///      - Void
    public init(field: String, value: String, type: ACMEncryptType = .plain) {
        self.field = field
        self.value = value
        self.type = type
    }
}
