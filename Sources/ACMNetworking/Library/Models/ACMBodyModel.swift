//
//  ACMBodyModel.swift
//

/// ACMBodyModel
///
/// A struct that holds the body payload
public struct ACMBodyModel {
    var key: String
    var value: Any

    /// Public Init function
    /// For creating body payload
    ///    - Parameters:
    ///      - key: Body payload key
    ///      - value: Body payload value
    ///    - Returns
    ///      - Void
    public init(key: String, value: Any) {
        self.key = key
        self.value = value
    }
}
