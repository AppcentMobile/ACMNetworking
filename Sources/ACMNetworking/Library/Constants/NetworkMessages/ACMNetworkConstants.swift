//
//  ACMNetworkConstants.swift
//

import Foundation

public enum ACMNetworkConstants {
    public static var errorMessage = "An error occurred."
    public static var responseInfoMessage = "RESPONSE:"
    public static var responseNullMessage = "Response null"
    public static var dataNullMessage = "Data null"
    public static var dataParseSuccessMessage = "Data parsed successfully"
    public static var dataParseErrorMessage = "Data parsing error : %@"
    public static var urlRequestErrorMessage = "URL Request Error"
    public static var httpStatusError = "HTTP Status error"
    public static var httpURLMessage = "HTTP URL:"
    public static var httpAuthHeadersMessage = "HTTP AUTH HEADERS:"
    public static var httpHeadersMessage = "HTTP HEADERS:"
    public static var httpQueryItemsMessage = "HTTP QUERYITEMS:"
    public static var httpBodyMessage = "HTTP BODY:"
    public static var httpRequestType = "HTTP Request TYPE:"
    public static var httpBodyMultipart = "Multipart data"
}

public struct ACMMultipartContentTypeModel {
    var type: String
    var boundary: String
}

public extension ACMNetworkConstants {
    static var multipartContentType: ACMMultipartContentTypeModel {
        ACMMultipartContentTypeModel(type: "multipart/form-data;",
                                     boundary: String(format: "boundary=com.ACMNetworking.%@", ProcessInfo.processInfo.globallyUniqueString))
    }

    static func multipartHeader(model: ACMMultipartContentTypeModel) -> ACMHeaderModel {
        ACMHeaderModel(field: "Content-Type", value: ACMStringUtils.shared.merge(list: [
            model.type,
            " ",
            model.boundary,
        ]))
    }

    static var multipartDataAccept: ACMHeaderModel {
        ACMHeaderModel(field: "Accept", value: "application/json")
    }
}
