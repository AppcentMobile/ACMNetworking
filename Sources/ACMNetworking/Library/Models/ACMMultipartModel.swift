//
//  ACMMultipartModel.swift
//

import Foundation

/// ACMMultipartModel
///
/// A struct that holds the multipart payload
public struct ACMMultipartModel {
    var params: [ACMBodyModel]?
    var data: Data?

    /// Public Init function
    /// For creating multipart
    ///    - Parameters:
    ///      - params: Multipart params
    ///      - data: Data for media
    ///    - Returns
    ///      - Void
    public init(params: [ACMBodyModel]? = nil, data: Data? = nil) {
        self.params = params
        self.data = data
    }
}
