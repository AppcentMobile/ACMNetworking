//
//  ACMNetworking+Extensions.swift
//

import Foundation

extension ACMNetworking {
    func baseRequest(to endpoint: ACMBaseEndpoint) -> URLRequest? {
        guard let urlRequest = endpoint.urlRequest else {
            endpoint.logger?.error(ACMNetworkConstants.urlRequestErrorMessage)
            return nil
        }

        var infoList = [
            ACMNetworkConstants.httpRequestType,
        ]

        if let methodRaw = endpoint.method?.rawValue {
            infoList.append(methodRaw)
        }

        let info = endpoint.stringUtils?.merge(list: infoList)
        endpoint.logger?.info(info)

        if let url = endpoint.url {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpURLMessage,
                "\(url)",
            ])
            endpoint.logger?.info(info)
        }

        if let authHeader = endpoint.authHeader {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpAuthHeadersMessage,
                "\(authHeader)",
            ])
            endpoint.logger?.info(info)
        }

        if let headers = endpoint.headers, headers.count > 0 {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpHeadersMessage,
                "\(headers)",
            ])
            endpoint.logger?.info(info)
        }

        if let queryItems = endpoint.queryItems, queryItems.count > 0 {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpQueryItemsMessage,
                "\(queryItems)",
            ])
            endpoint.logger?.info(info)
        }

        if let params = endpoint.params {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpBodyMessage,
                params.paramsRaw,
            ])
            endpoint.logger?.info(info)
        } else if let data = endpoint.mediaData {
            let info = endpoint.stringUtils?.merge(list: [
                ACMNetworkConstants.httpBodyMessage,
                String(format: ACMNetworkConstants.httpBodyMultipart, "\(data.length)"),
            ])
            endpoint.logger?.info(info)
        }

        return urlRequest
    }
}

extension ACMNetworking: URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {
    /// URL Session data task for stream requests
    public func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive data: Data) {
        let dataString = String(data: data, encoding: .utf8) ?? ""
        if !dataString.contains("[DONE]") {
            let response = dataString.components(separatedBy: "\n")
                .filter { !$0.replacingOccurrences(of: " ", with: "").isEmpty }
                .map { $0.replacingOccurrences(of: "data:", with: "")
                    .replacingOccurrences(of: " ", with: "")
                }
            for item in response {
                if let data = item.toData {
                    onPartial?(data)
                }
            }
        }
    }

    /// URL Session didFinishCollecting
    ///
    ///  - Parameters:
    ///     - session: URL Session
    ///     - task: URL session task
    ///     - didFinishCollecting: Metrics that gathered
    public func urlSession(_: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        let message = getBaseEndpoint()?.stringUtils?.merge(list: [
            "didFinishCollecting",
            task.description,
            "metrics",
            "\(metrics.taskInterval)",
        ])
        getBaseEndpoint()?.logger?.info(message)
    }

    /// URL Session taskIsWaitingForConnectivity
    ///
    ///  - Parameters:
    ///     - session: URL Session
    ///     - task: URL session task
    public func urlSession(_: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        let message = getBaseEndpoint()?.stringUtils?.merge(list: [
            "taskIsWaitingForConnectivity",
            task.description,
        ])
        getBaseEndpoint()?.logger?.info(message)
    }

    /// URL Session didSendBodyData
    ///
    ///  - Parameters:
    ///     - session: URL Session
    ///     - task: URL session task
    ///     - bytesSent: DidSendBodyData
    ///     - totalBytesSent
    ///     - totalBytesExpectedToSend
    public func urlSession(_: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let message = getBaseEndpoint()?.stringUtils?.merge(list: [
            "task",
            task.description,
            "didSendBodyData",
            "\(bytesSent)",
            "totalBytesSent",
            "\(totalBytesSent)",
            "totalBytesExpectedToSend",
            "\(totalBytesExpectedToSend)",
        ])
        getBaseEndpoint()?.logger?.info(message)
    }
}
