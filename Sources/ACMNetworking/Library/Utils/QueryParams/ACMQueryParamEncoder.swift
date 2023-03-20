//
//  ACMQueryParamEncoder.swift
//

import Foundation

final class ACMQueryParamEncoder {
    static func encode(with list: [ACMQueryModel]) -> [URLQueryItem] {
        return list.map { URLQueryItem(name: $0.name, value: $0.value) }
    }
}
