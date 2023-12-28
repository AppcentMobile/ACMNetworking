//
//  ACMEndpoint.swift
//

import Foundation

/// ACMEndpoint
///
/// Base generator for building the endpoint
public final class ACMEndpoint {
    /// Base init
    ///
    /// Init method for creating new object
    public init() {
        encryption = ACMEncryptionUtils()
    }

    var encryption: ACMEncryptionUtils?
    var mainEndpoint: ACMBaseEndpoint?
    var config: ACMPlistModel?
    var configOverride: Bool = false
    var host: String?
    var scheme: ACMBaseScheme = .https
    var path = ""
    var queryItems: [URLQueryItem]?
    var queryItemsModel: [ACMQueryModel]?
    var params: [String: Any?]?
    var paramsModel: [ACMBodyModel]?
    var headers: NSMutableDictionary?
    var headersModel: [ACMHeaderModel]?
    var method: ACMBaseMethod = .get
    var authHeader: ACMAuthModel?
    var mediaData: NSMutableData?
    var retryCount: Int?
    var isStream: Bool = false
    var downloadURL: String?

    /// Set config model
    ///
    /// - Parameters:
    ///     - config: ACMPlistModel
    ///
    /// - Returns
    ///     - Self
    public func set(config: ACMPlistModel) -> Self {
        self.config = config
        return self
    }

    /// Update override plist
    ///
    /// - Parameters:
    ///     - overrideConfig: Bool
    ///
    /// - Returns
    ///     - Self
    public func update(configOverride: Bool) -> Self {
        self.configOverride = configOverride
        return self
    }

    /// Sets the Host
    ///
    /// - Parameters:
    ///     - host: Given host
    ///
    /// - Returns
    ///     - Self
    public func set(host: String) -> Self {
        self.host = host
        return self
    }

    /// Sets the Scheme
    ///
    /// - Parameters:
    ///     - scheme: Given scheme
    ///
    /// - Returns
    ///     - Self
    public func set(scheme: ACMBaseScheme) -> Self {
        self.scheme = scheme
        return self
    }

    /// Sets the Path
    ///
    /// - Parameters:
    ///     - path: Given path with string
    ///
    /// - Returns
    ///     - Self
    public func set(path: String) -> Self {
        self.path = path
        return self
    }

    /// Sets the Path
    ///
    /// - Parameters:
    ///     - path: Given path with model object
    ///
    /// - Returns
    ///     - Self
    public func set(path: ACMPathModel) -> Self {
        let pathQuery = [path.path, path.value].joined(separator: "/")
        self.path = pathQuery
        return self
    }

    /// Sets the raw url string
    ///
    /// - Parameters:
    ///     - rawURL: Given url string
    ///
    /// - Returns
    ///     - Self
    public func set(downloadURL: String) -> Self {
        self.downloadURL = downloadURL
        return self
    }

    /// Sets the request method
    ///
    /// - Parameters:
    ///     - method: Given method with model object
    ///
    /// - Returns
    ///     - Self
    public func set(method: ACMBaseMethod) -> Self {
        self.method = method
        return self
    }

    /// Sets stream response support enabled
    ///
    /// - Parameters:
    ///     - method: Given method with model object
    ///
    /// - Returns
    ///     - Self
    public func set(isStream: Bool) -> Self {
        self.isStream = isStream
        return self
    }

    /// Add the request header
    ///
    /// - Parameters:
    ///     - header: Given header with model object
    ///
    /// - Returns
    ///     - Self
    public func add(header: ACMHeaderModel) -> Self {
        var headerList = [ACMHeaderModel]()

        var headerFiltered = header
        if let encVal = encryption?.encrypt(value: header.value, type: header.type) as? String {
            headerFiltered.value = encVal
        }

        if let list = headersModel, list.count > 0 {
            headerList = list
            headerList.append(headerFiltered)
        } else {
            headerList.append(headerFiltered)
        }

        headersModel = headerList
        headers = ACMHeadersEncoder.encode(with: headerList)
        return self
    }

    /// Add request headers
    ///
    /// - Parameters:
    ///     - headers: Given header with model object list
    ///
    /// - Returns
    ///     - Self
    public func add(headers: [ACMHeaderModel]) -> Self {
        self.headers = ACMHeadersEncoder.encode(with: headers)
        return self
    }

    /// Add the auth header
    ///
    /// - Parameters:
    ///     - authHeader: Given auth header with string
    ///
    /// - Returns
    ///     - Self
    public func add(authHeader: ACMAuthModel) -> Self {
        self.authHeader = authHeader
        return self
    }

    /// Add the query item
    ///
    /// - Parameters:
    ///     - queryItem: Given query item with model object
    ///
    /// - Returns
    ///     - Self
    public func add(queryItem: ACMQueryModel) -> Self {
        var queryList = [ACMQueryModel]()

        var queryFiltered = queryItem
        if let encVal = encryption?.encrypt(value: queryFiltered.value, type: queryItem.type) as? String {
            queryFiltered.value = encVal
        }

        if let list = queryItemsModel, list.count > 0 {
            queryList = list
            queryList.append(queryFiltered)
        } else {
            queryList.append(queryFiltered)
        }

        queryItemsModel = queryList
        queryItems = ACMQueryParamEncoder.encode(with: queryList)
        return self
    }

    /// Add query items
    ///
    /// - Parameters:
    ///     - queryItems: Given query items with model object list
    ///
    /// - Returns
    ///     - Self
    public func add(queryItems: [ACMQueryModel]) -> Self {
        self.queryItems = ACMQueryParamEncoder.encode(with: queryItems)
        return self
    }

    /// Add body payload
    ///
    /// - Parameters:
    ///     - param: Given param with model object
    ///
    /// - Returns
    ///     - Self
    public func add(param: ACMBodyModel) -> Self {
        var paramList = [ACMBodyModel]()

        var paramFiltered = param
        if let encVal = encryption?.encrypt(value: param.value, type: param.type) {
            paramFiltered.value = encVal
        }

        if let list = paramsModel, list.count > 0 {
            paramList = list
            paramList.append(paramFiltered)
        } else {
            paramList.append(paramFiltered)
        }

        paramsModel = paramList
        params = ACMBodyEncoder.encode(with: paramList)
        return self
    }

    /// Add body payload list
    ///
    /// - Parameters:
    ///     - params: Given params with model object list
    ///
    /// - Returns
    ///     - Self
    public func add(params: [ACMBodyModel]) -> Self {
        self.params = ACMBodyEncoder.encode(with: params)
        return self
    }

    /// Sets the retry count
    ///
    /// - Parameters:
    ///     - count: Given retry count with value
    ///
    /// - Returns
    ///     - Self
    public func retry(count: Int) -> Self {
        retryCount = count
        return self
    }

    /// Adds the media
    ///
    /// - Parameters:
    ///     - media: Given media with model object
    ///
    /// - Returns
    ///     - Self
    public func add(media: ACMMultipartModel) -> Self {
        let fileData = media.data
        let contentType = ACMNetworkConstants.multipartContentType
        let boundary = contentType.boundary
        let fileModel = fileData?.fileModel
        let fileName = mainEndpoint?.stringUtils?.merge(list: [
            ProcessInfo.processInfo.globallyUniqueString,
            fileModel?.ext ?? "",
        ]) ?? ""

        let endpoint = set(method: .post)
            .add(header: ACMNetworkConstants.multipartHeader(model: contentType, utils: mainEndpoint?.stringUtils))
            .add(header: ACMNetworkConstants.multipartDataAccept)

        let body = NSMutableData()
        if let data = "--\(boundary)\r\n".toData {
            body.append(data)
        }

        if let data = "\(fileName)\r\n".toData {
            body.append(data)
        }

        if let data = "--\(boundary)\r\n".toData {
            body.append(data)
        }

        if let params = media.params {
            let paramsRaw = params.map {
                " \($0.key)=\($0.value);"
            }.joined(separator: "")

            let contentDisposition = mainEndpoint?.stringUtils?.merge(list: [
                "Content-Disposition: form-data;",
                paramsRaw,
                "\r\n",
            ])

            if let data = contentDisposition?.toData {
                body.append(data)
            }
        }

        if let data = String(format: "Content-Type:%@\r\n\r\n", fileModel?.mime ?? "").data(using: .utf8) {
            body.append(data)
        }

        if let data = fileData {
            body.append(data)
        }

        if let data = "\r\n".data(using: String.Encoding.utf8) {
            body.append(data)
        }

        if let data = "--\(boundary)--\r\n".data(using: String.Encoding.utf8) {
            body.append(data)
        }

        endpoint.mediaData = body

        return endpoint
    }

    /// Generic build
    ///
    /// - Returns
    ///     - Self
    public func build() -> ACMBaseEndpoint {
        let hasStreamEnabledAsParam = paramsModel?.first(where: { $0.key == "stream" && ($0.value as? Bool) == true }) != nil

        let streamSupported = isStream || hasStreamEnabledAsParam

        mainEndpoint = ACMBaseEndpoint(config: config, configOverride: configOverride, host: host, scheme: scheme, path: path, queryItems: queryItems, params: params, headers: headers, method: method, authHeader: authHeader, mediaData: mediaData, retryCount: retryCount, isStream: streamSupported, downloadURL: downloadURL)

        return mainEndpoint ?? ACMBaseEndpoint()
    }
}
