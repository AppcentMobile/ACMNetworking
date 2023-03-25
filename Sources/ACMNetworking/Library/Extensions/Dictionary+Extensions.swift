//
//  Dictionary+Extensions.swift
//

import Foundation

extension Dictionary where Key == String, Value == Any? {
    var paramsRaw: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return ""
        }

        return String(data: data, encoding: .utf8) ?? ""
    }
}
