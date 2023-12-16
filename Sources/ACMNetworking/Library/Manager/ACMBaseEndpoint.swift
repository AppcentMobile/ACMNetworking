//
//  ACMBaseEndpoint.swift
//

import Foundation

/// ACMBaseEndpoint
///
/// Base endpoint struct for holding endpoint information
public struct ACMBaseEndpoint {
    // MARK: Config

    var config: ACMPlistModel?

    // MARK: Override fetching config file

    var configOverride: Bool = false

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

    // MARK: Stream

    var stream: Bool? = false

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

    var authHeader: ACMAuthModel?

    // MARK: Retry count

    var retryCount: Int?

    // MARK: Data for media upload

    var mediaData: NSMutableData?

    // MARK: Generated url request

    var urlRequest: URLRequest? {
        guard let url = url else {
            ACMBaseLogger.error(ACMNetworkConstants.errorURLMessage)
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        if let header = authHeader {
            urlRequest.setValue(header.rawHeader, forHTTPHeaderField: ACMNetworkConstants.headerAuthorization)
        }

        if let basicHeaders = headers {
            for header in basicHeaders {
                if let key = header.key as? String, let value = header.value as? String {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
        }

        if let params = params {
            let header = ACMNetworkConstants.headerContentTypeJSON
            let httpBody = try? JSONSerialization.data(withJSONObject: params)
            urlRequest.httpBody = httpBody
            urlRequest.setValue(header.value, forHTTPHeaderField: header.field)
        } else if let data = mediaData as? Data {
            urlRequest.httpBody = data
        }

        return urlRequest
    }

    func session(delegate: URLSessionDelegate) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = config?.timeout ?? 0
        configuration.timeoutIntervalForResource = config?.timeout ?? 0

        let delegateQueue = OperationQueue()
        delegateQueue.name = "ACMNetworking.operation.queue"

        return URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
    }

    init(config: ACMPlistModel? = nil, configOverride: Bool, host: String? = nil, scheme: ACMBaseScheme, path: String = "", queryItems: [URLQueryItem]? = nil, params: [String: Any?]? = nil, headers: NSMutableDictionary? = nil, method: ACMBaseMethod, authHeader: ACMAuthModel? = nil, mediaData: NSMutableData? = nil, retryCount: Int? = nil) {
        if let config = config {
            self.config = config
        } else {
            self.config = ACMPlistUtils.shared.config()
        }
        ACMBaseLogger.shared.config = self.config
        ACMNetworkingConstants.configOverride = configOverride
        if let host = host {
            self.host = host
        } else {
            self.host = self.config?.filteredBaseURL
        }
        self.scheme = scheme
        self.path = path
        self.queryItems = queryItems
        self.params = params
        self.headers = headers
        self.method = method
        self.authHeader = authHeader
        self.mediaData = mediaData
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
