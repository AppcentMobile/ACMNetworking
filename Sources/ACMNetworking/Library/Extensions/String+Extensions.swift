//
//  String+Extensions.swift
//

import Foundation

extension String {
    var toData: Data? {
        data(using: String.Encoding.utf8)
    }
}
