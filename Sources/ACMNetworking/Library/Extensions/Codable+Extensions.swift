//
//  Codable+Extensions.swift
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let list = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else { return nil }
        var formattedList = [String: Any]()
        list.forEach({ (key: String, value: Any) in
            if let strValue = value as? String {
                formattedList[key] = strValue
            } else if let strValue = value as? [String: Any] {
                var innerList = [String: Any]()
                strValue.forEach { (key: String, value: Any) in
                    if let item = value as? String {
                        if let data = item.data(using: .utf8, allowLossyConversion: true),
                            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                            innerList[key] = json
                        } else {
                            innerList[key] = item
                        }
                    }
                }
                formattedList[key] = innerList
            }
        })
        return formattedList
    }
}
