//
//  ACMEndpoint.swift
//

import Foundation

public final class ACMEndpoint {
    public init() {}

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
    var authHeader: String?
    var mediaData: NSMutableData?
    var retryCount: Int?

    public func set(host: String) -> Self {
        self.host = host
        return self
    }

    public func set(scheme: ACMBaseScheme) -> Self {
        self.scheme = scheme
        return self
    }

    public func set(path: String) -> Self {
        self.path = path
        return self
    }

    public func set(path: ACMPathModel) -> Self {
        let pathQuery = [path.path, path.value].joined(separator: "/")
        self.path = pathQuery
        return self
    }

    public func set(method: ACMBaseMethod) -> Self {
        self.method = method
        return self
    }

    public func add(header: ACMHeaderModel) -> Self {
        var headerList = [ACMHeaderModel]()
        if let list = headersModel, list.count > 0 {
            headerList = list
            headerList.append(header)
        } else {
            headerList.append(header)
        }

        headersModel = headerList
        headers = ACMHeadersEncoder.encode(with: headerList)
        return self
    }

    public func add(headers: [ACMHeaderModel]) -> Self {
        self.headers = ACMHeadersEncoder.encode(with: headers)
        return self
    }

    public func add(authHeader: String) -> Self {
        self.authHeader = authHeader
        return self
    }

    public func add(queryItem: ACMQueryModel) -> Self {
        var queryList = [ACMQueryModel]()
        if let list = queryItemsModel, list.count > 0 {
            queryList = list
            queryList.append(queryItem)
        } else {
            queryList.append(queryItem)
        }

        queryItemsModel = queryList
        queryItems = ACMQueryParamEncoder.encode(with: queryList)
        return self
    }

    public func add(queryItems: [ACMQueryModel]) -> Self {
        self.queryItems = ACMQueryParamEncoder.encode(with: queryItems)
        return self
    }

    public func add(param: ACMBodyModel) -> Self {
        var paramList = [ACMBodyModel]()
        if let list = paramsModel, list.count > 0 {
            paramList = list
            paramList.append(param)
        } else {
            paramList.append(param)
        }

        paramsModel = paramList
        params = ACMBodyEncoder.encode(with: paramList)
        return self
    }

    public func add(params: [ACMBodyModel]) -> Self {
        self.params = ACMBodyEncoder.encode(with: params)
        return self
    }

    public func retry(count: Int) -> Self {
        retryCount = count
        return self
    }

    public func add(model: ACMMultipartModel) -> Self {
        let fileData = model.data
        let contentType = ACMNetworkConstants.multipartContentType
        let boundary = contentType.boundary
        let fileModel = fileData?.fileModel
        let fileName = ACMStringUtils.shared.merge(list: [
            ProcessInfo.processInfo.globallyUniqueString,
            fileModel?.ext ?? "",
        ])

        let endpoint = set(method: .post)
            .add(header: ACMNetworkConstants.multipartHeader(model: contentType))
            .add(header: ACMNetworkConstants.multipartDataAccept)

        let body = NSMutableData()
        if let data = "--\(boundary)\r\n".toData {
            body.append(data)
        }

        let contentDispositionMini = ACMStringUtils.shared.merge(list: [
            "Content-Disposition: form-data;",
            " ",
            model.key ?? "",
            "=",
            model.value ?? "",
            "\r\n\r\n",
        ])

        if let data = contentDispositionMini.toData {
            body.append(data)
        }

        if let data = "\(fileName)\r\n".toData {
            body.append(data)
        }

        if let data = "--\(boundary)\r\n".toData {
            body.append(data)
        }

        let contentDisposition = ACMStringUtils.shared.merge(list: [
            "Content-Disposition: form-data;",
            " ",
            model.key ?? "",
            "=",
            model.value ?? "",
            ";",
            " ",
            model.fileKey ?? "",
            "=",
            model.fileValue ?? "",
            "\r\n",
        ])

        if let data = contentDisposition.toData {
            body.append(data)
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

    public func build() -> ACMBaseEndpoint {
        return ACMBaseEndpoint(host: host, scheme: scheme, path: path, queryItems: queryItems, params: params, headers: headers, method: method, authHeader: authHeader, mediaData: mediaData, retryCount: retryCount)
    }
}
