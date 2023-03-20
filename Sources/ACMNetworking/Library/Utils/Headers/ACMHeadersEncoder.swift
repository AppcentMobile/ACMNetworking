//
//  ACMHeadersEncoder.swift
//

import Foundation

final class ACMHeadersEncoder {
    static func encode(with list: [ACMHeaderModel]) -> NSMutableDictionary {
        return list.reduce(into: NSMutableDictionary()) {
            $0[$1.field] = $1.value
        }
    }
}
