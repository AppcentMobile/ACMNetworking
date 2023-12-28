//
//  ACMBodyModel.swift
//

/// ACMBodyModel
///
/// A struct that holds the body payload
public struct ACMBodyModel {
    var key: String
    var value: Any
    var type: ACMEncryptType

    /// Public Init function
    /// For creating body payload
    ///    - Parameters:
    ///      - key: Body payload key
    ///      - value: Body payload value
    ///    - Returns
    ///      - Void
    public init(key: String, value: Any, type: ACMEncryptType = .plain) {
        self.key = key
        self.value = value
        self.type = type
    }
}
