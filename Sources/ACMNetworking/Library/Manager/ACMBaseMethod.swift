//
//  ACMBaseMethod.swift
//

/// ACMBaseMethod
///
/// Enumeration for holding network methods
public enum ACMBaseMethod: String {
    /// Request type for GET
    case get = "GET"
    /// Request type for POST
    case post = "POST"
    /// Request type for PATCH
    case patch = "PATCH"
    /// Request type for DELETE
    case delete = "DELETE"
    /// Request type for PUT
    case put = "PUT"
    /// Request type for HEAD
    case head = "HEAD"
    /// Request type for OPTIONS
    case options = "OPTIONS"
}
