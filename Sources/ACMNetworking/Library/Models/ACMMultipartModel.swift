//
//  ACMMultipartModel.swift
//

import Foundation

public struct ACMMultipartModel {
    var params: [ACMBodyModel]?
    var data: Data?

    public init(params: [ACMBodyModel]? = nil, data: Data? = nil) {
        self.params = params
        self.data = data
    }
}
