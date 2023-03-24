//
//  ACMMultipartModel.swift
//

import Foundation

public struct ACMMultipartModel {
    var key: String?
    var value: String?
    var fileKey: String?
    var fileValue: String?
    var data: Data?

    public init(key: String? = nil, value: String? = nil, fileKey: String? = nil, fileValue: String? = nil, data: Data? = nil) {
        self.key = key
        self.value = value
        self.fileKey = fileKey
        self.fileValue = fileValue
        self.data = data
    }
}
