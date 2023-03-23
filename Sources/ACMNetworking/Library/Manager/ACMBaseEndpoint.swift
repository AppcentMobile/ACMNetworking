//
//  ACMBaseEndpoint.swift
//

import Foundation

public struct ACMBaseEndpoint {
    // MARK: API host

    var host: String?

    // MARK: API scheme, Default https

    var scheme: ACMBaseScheme = .https

    // MARK: The path for api access

    var path = ""

    // MARK: Url Parameters

    var queryItems: [URLQueryItem]?

    // MARK: Request parameters

    var params: [String: Any?]?

    // MARK: Headers

    var headers: NSMutableDictionary?

    // MARK: Default method: GET

    var method: ACMBaseMethod = .get

    // MARK: Generated URL for making request

    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = updatedPath
        components.queryItems = queryItems
        return components.url
    }

    // MARK: Auth header

    var authHeader: String?

    // MARK: Retry count

    var retryCount: Int?

    // MARK: Generated url request

    var urlRequest: URLRequest? {
        guard let url = url else {
            ACMBaseLogger.error("Error: URL couldn't create")
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        if let header = authHeader {
            urlRequest.setValue(header, forHTTPHeaderField: "Authorization")
        }

        if let basicHeaders = headers {
            for header in basicHeaders {
                if let key = header.key as? String, let value = header.value as? String {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
        }

        if method != .get, let params = params {
            let httpBody = try? JSONSerialization.data(withJSONObject: params)
            urlRequest.httpBody = httpBody
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }

        return urlRequest
    }

    private var config: ACMPlistModel {
        guard let model = ACMPlistUtils.shared.config else {
            return ACMPlistModel(baseURL: "", timeout: 0, isLogEnabled: false)
        }
        return model
    }

    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = config.timeout
        configuration.timeoutIntervalForResource = config.timeout

        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }

    init(host: String? = nil, scheme: ACMBaseScheme, path: String = "", queryItems: [URLQueryItem]? = nil, params: [String: Any?]? = nil, headers: NSMutableDictionary? = nil, method: ACMBaseMethod, authHeader: String? = nil, retryCount: Int? = nil) {
        if let host = host {
            self.host = host
        } else {
            self.host = config.baseURL
        }
        self.scheme = scheme
        self.path = path
        self.queryItems = queryItems
        self.params = params
        self.headers = headers
        self.method = method
        self.authHeader = authHeader
        self.retryCount = retryCount
    }
}

private extension ACMBaseEndpoint {
    var updatedPath: String {
        if path.starts(with: "/") {
            return path
        } else {
            return String(format: "/%@", path)
        }
    }
}
