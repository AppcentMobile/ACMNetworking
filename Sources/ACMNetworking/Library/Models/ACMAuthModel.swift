//
//  ACMAuthModel.swift
//
//
//  Created by burak on 1.04.2023.
//

/// ACMAuthModel
///
/// A struct that holds the body payload
public struct ACMAuthModel {
    var type: ACMAuthType
    var value: Any

    var rawHeader: String {
        switch type {
        case .basic:
            guard let model = value as? ACMBasicAuthModel else { return "" }
            let header = String(format: "%@:%@", model.user, model.password)
            guard let data = header.data(using: String.Encoding.utf8) else { return "" }
            return String(format: "Basic %@", data.base64EncodedString())
        case .bearer:
            guard let header = value as? String else { return "" }
            return String(format: "Bearer %@", header)
        default:
            guard let header = value as? String else { return "" }
            return header
        }
    }

    /// Public Init function
    /// For creating auth header
    ///    - Parameters:
    ///      - key: Body payload key
    ///      - value: Body payload value
    ///    - Returns
    ///      - Void
    public init(type: ACMAuthType, value: Any) {
        self.type = type
        self.value = value
    }
}

/// ACMAuthType
///
/// A struct that holds the authorization types
public enum ACMAuthType {
    case basic
    case bearer
    case raw
}

/// ACMBasicAuthModel
///
/// A struct that holds the authorization payload
public struct ACMBasicAuthModel {
    var user: String
    var password: String
}

/// ACMBearerAuthModel
///
/// A struct that holds the authorization payload
public struct ACMBearerAuthModel {
    var bearer: String
}
