//
//  ACMNetworkConstants.swift
//

import Foundation

/// ACMNetworkConstants
///
/// Enumaration for holding the network message constants
public enum ACMNetworkConstants {
    /// Error message for generic network error
    public static var errorMessage = "An error occurred."
    /// Error message if url is not created and invalid
    public static var errorURLMessage = "Error: URL couldn't create"
    /// Info message for generic response
    public static var responseInfoMessage = "RESPONSE:"
    /// Error message if response is empty
    public static var responseNullMessage = "Response null"
    /// Error message if data is empty
    public static var dataNullMessage = "Data null"
    /// Success message for data parsing successfully completed
    public static var dataParseSuccessMessage = "Data parsed successfully"
    /// Error message if data is invalid and could not be parsed
    public static var dataParseErrorMessage = "Data parsing error : %@"
    /// Error message for generic url request error
    public static var urlRequestErrorMessage = "URL Request Error"
    /// Error message for generic status error
    public static var httpStatusError = "HTTP Status error"
    /// Info message for url value
    public static var httpURLMessage = "HTTP URL:"
    /// Info message for autharization headers
    public static var httpAuthHeadersMessage = "HTTP AUTH HEADERS:"
    /// Info message for headers
    public static var httpHeadersMessage = "HTTP HEADERS:"
    /// Info message for query items
    public static var httpQueryItemsMessage = "HTTP QUERYITEMS:"
    /// Info message for body payload
    public static var httpBodyMessage = "HTTP BODY:"
    /// Info message for request type
    public static var httpRequestType = "HTTP Request TYPE:"
    /// Info message for multipart with data length
    public static var httpBodyMultipart = "Multipart data, length: %@"
    /// Info message for retry mechanism
    public static var httpRetryCount = "Current retry count is %d, total retry count is %d"
    /// Error message if data is invalid and could not be parsed
    public static var genericErrorMessage = "Generic error : %@"
    /// Message if ACMNetworking deinited
    public static var managerDeinitMessage = "ACMNetworking deinited"
    /// Download
    public static var downloadMessage = "ACMNetworking download message"
}

public extension ACMNetworkConstants {
    /// Content type model for holding multipart header with boundary
    static var multipartContentType: ACMMultipartContentTypeModel {
        ACMMultipartContentTypeModel(type: "multipart/form-data;",
                                     boundary: String(format: "boundary=com.ACMNetworking.%@", ProcessInfo.processInfo.globallyUniqueString))
    }

    /// Header for holding multipart header with content type
    static func multipartHeader(model: ACMMultipartContentTypeModel, utils: ACMStringUtils?) -> ACMHeaderModel {
        ACMHeaderModel(field: "Content-Type", value: utils?.merge(list: [
            model.type,
            " ",
            model.boundary,
        ]) ?? "")
    }

    /// Header for holding multipart accept type
    static var multipartDataAccept: ACMHeaderModel {
        ACMHeaderModel(field: "Accept", value: "application/json")
    }
}

public extension ACMNetworkConstants {
    /// Header for holding json content type
    static var headerContentTypeJSON = ACMHeaderModel(field: "Content-Type", value: "application/json; charset=utf-8")
    /// Header for authorization
    static var headerAuthorization = "Authorization"
}
