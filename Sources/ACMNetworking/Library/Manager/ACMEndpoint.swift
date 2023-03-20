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

    public func set(host: String) -> ACMEndpoint {
        self.host = host
        return self
    }

    public func set(scheme: ACMBaseScheme) -> ACMEndpoint {
        self.scheme = scheme
        return self
    }

    public func set(path: String) -> ACMEndpoint {
        self.path = path
        return self
    }

    public func set(path: ACMPathModel) -> ACMEndpoint {
        let pathQuery = [path.path, path.value].joined(separator: "/")
        self.path = pathQuery
        return self
    }

    public func set(method: ACMBaseMethod) -> ACMEndpoint {
        self.method = method
        return self
    }

    public func add(header: ACMHeaderModel) -> ACMEndpoint {
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

    public func add(headers: [ACMHeaderModel]) -> ACMEndpoint {
        self.headers = ACMHeadersEncoder.encode(with: headers)
        return self
    }

    public func add(authHeader: String) -> ACMEndpoint {
        self.authHeader = authHeader
        return self
    }

    public func add(queryItem: ACMQueryModel) -> ACMEndpoint {
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

    public func add(queryItems: [ACMQueryModel]) -> ACMEndpoint {
        self.queryItems = ACMQueryParamEncoder.encode(with: queryItems)
        return self
    }

    public func add(param: ACMBodyModel) -> ACMEndpoint {
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

    public func add(params: [ACMBodyModel]) -> ACMEndpoint {
        self.params = ACMBodyEncoder.encode(with: params)
        return self
    }

    public func build() -> ACMBaseEndpoint {
        return ACMBaseEndpoint(host: host, scheme: scheme, path: path, queryItems: queryItems, params: params, headers: headers, method: method, authHeader: authHeader)
    }
}
