//
//  ACMPropertyListSerializationError.swift
//

import Foundation

public enum ACMPropertyListSerializationError: Error {
    case fileNotFound
    case fileNotParsed
    case dataNotAvailable
    case modelNotParsed
    case configNotLoaded
    case dataCorrupted(context: DecodingError.Context)
    case keyNotFound(key: CodingKey, context: DecodingError.Context)
    case valueNotFound(value: Any, context: DecodingError.Context)
    case typeMismatch(type: Any, context: DecodingError.Context)
}

extension ACMPropertyListSerializationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return NSLocalizedString(String(format: "File %@.plist not found", "BAConfig"), comment: "fileNotFound")
        case .fileNotParsed:
            return NSLocalizedString("File could not be parsed", comment: "fileNotParsed")
        case .dataNotAvailable:
            return NSLocalizedString("Data is not available", comment: "dataNotAvailable")
        case .modelNotParsed:
            return NSLocalizedString("Model could not be parsed", comment: "modelNotParsed")
        case .configNotLoaded:
            return NSLocalizedString("Config could not be loaded", comment: "configNotLoaded")
        case let .dataCorrupted(context):
            return NSLocalizedString(context.debugDescription, comment: "dataCorrupted")
        case let .keyNotFound(key, context):
            let description = "Key \(key) not found: \(context.debugDescription) codingPath: \(context.codingPath)"
            return NSLocalizedString(description, comment: "keyNotFound")
        case let .valueNotFound(value, context):
            let description = "Value \(value) not found: \(context.debugDescription) codingPath: \(context.codingPath)"
            return NSLocalizedString(description, comment: "valueNotFound")
        case let .typeMismatch(type, context):
            let description = "Type \(type) mismatch: \(context.debugDescription) codingPath: \(context.codingPath)"
            return NSLocalizedString(description, comment: "typeMismatch")
        }
    }
}
