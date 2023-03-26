//
//  ACMPropertyListSerializationError.swift
//

import Foundation

/// ACMPropertyListSerializationError
///
/// Enumeration for holding the data serialization errors
public enum ACMPropertyListSerializationError: Error {
    /// Serialization error when file is not found in plist
    case fileNotFound
    /// Serialization error when file plist is not parsed
    case fileNotParsed
    /// Serialization error when plist data not available
    case dataNotAvailable
    /// Serialization error when plist model not parsed
    case modelNotParsed
    /// Serialization error when config not loaded
    case configNotLoaded
    /// Serialization error when plist data is corrupted
    case dataCorrupted(context: DecodingError.Context)
    /// Serialization error when coding key is not found
    case keyNotFound(key: CodingKey, context: DecodingError.Context)
    /// Serialization error when plist property value is not found
    case valueNotFound(value: Any, context: DecodingError.Context)
    /// Serialization error when value type is not matched in plist
    case typeMismatch(type: Any, context: DecodingError.Context)
}

extension ACMPropertyListSerializationError: LocalizedError {
    /// Error description holds plist serialization errors
    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return NSLocalizedString(String(format: "File %@.%@ not found", ACMPListContants.fileName, ACMPListContants.fileExtension), comment: "fileNotFound")
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
