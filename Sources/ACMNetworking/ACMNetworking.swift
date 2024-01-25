//
//  ACMNetworking.swift
//

import Foundation

/// ACMNetworking, make requests easily
public class ACMNetworking: NSObject {
    var endpoint: ACMEndpoint?

    public func getBaseEndpoint() -> ACMBaseEndpoint? {
        getEndpoint().build()
    }

    public func getEndpoint() -> ACMEndpoint {
        endpoint ?? ACMEndpoint()
    }

    public func getPlistUtils() -> ACMPlistUtils {
        getBaseEndpoint()?.plistUtils ?? ACMPlistUtils()
    }

    public func getStrUtils() -> ACMStringUtils {
        getBaseEndpoint()?.stringUtils ?? ACMStringUtils()
    }

    var session: URLSession?
    var requestTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
    var taskProgress: NSKeyValueObservation?

    var onPartial: ACMGenericCallbacks.StreamCallback?

    /// Public Init function
    /// For creating object with SDK
    override public init() {
        super.init()
        endpoint = ACMEndpoint()
    }

    /// Cancels the current network request
    public func cancel() {
        cancelRequestTask()
        cancelDownloadTask()
        session?.invalidateAndCancel()
        session = nil
        taskProgress?.invalidate()
        taskProgress = nil
        endpoint = nil
    }

    private func cancelRequestTask() {
        if requestTask?.state == .running {
            requestTask?.cancel()
        }
        requestTask = nil
    }

    private func cancelDownloadTask() {
        if downloadTask?.state == .running {
            downloadTask?.cancel()
        }
        downloadTask = nil
    }
}
