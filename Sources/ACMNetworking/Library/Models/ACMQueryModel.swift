//
//  ACMQueryModel.swift
//

/// ACMQueryModel
///
/// A struct that holds the query
public struct ACMQueryModel {
    var name: String
    var value: String
    var type: ACMEncryptType

    /// Public Init function
    /// For creating query
    ///    - Parameters:
    ///      - name: Query name
    ///      - value: Query value
    ///    - Returns
    ///      - Void
    public init(name: String, value: String, type: ACMEncryptType = .plain) {
        self.name = name
        self.value = value
        self.type = type
    }
}
