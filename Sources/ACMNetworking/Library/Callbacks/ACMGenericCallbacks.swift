//
//  ACMGenericCallbacks.swift
//

import Foundation

/// ACMGenericCallbacks
///
/// Enumaration for holding the callbacks
public enum ACMGenericCallbacks {
    /// Void callback for generic closures
    public typealias VoidCallback = (() -> Void)?
    /// Error callback for generic closures
    public typealias ErrorCallback = ((ACMBaseNetworkError?) -> Void)?
    /// Info callback with success check and error for generic closures
    public typealias InfoCallback = ((Bool?, Error?) -> Void)?
    /// Success callback with generic response for closures
    public typealias ResponseCallback<Codable> = ((Codable) -> Void)?
    /// Success callback with generic response for closures
    public typealias DownloadCallback = ((ACMDownloadModel) -> Void)?
    /// Progress callback with generic response for closures
    public typealias ProgressCallback = ((ACMProgressModel) -> Void)?
    /// Success callback with generic response for closures
    public typealias StreamCallback = (Data) -> Void
}
