//
//  ACMPathModel.swift
//

/// ACMPathModel
///
/// A struct that holds the path data
public struct ACMPathModel {
    var path: String
    var value: String

    /// Public Init function
    /// For creating path
    ///    - Parameters:
    ///      - path: Path name
    ///      - value: Path value
    ///    - Returns
    ///      - Void
    public init(path: String, value: String) {
        self.path = path
        self.value = value
    }
}
