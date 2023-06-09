//
//  ACMGenericCallbacks.swift
//

/// ACMGenericCallbacks
///
/// Enumaration for holding the callbacks
public enum ACMGenericCallbacks {
    /// Void callback for generic closures
    public typealias VoidCallback = (() -> Void)?
    /// Error callback for generic closures
    public typealias ErrorCallback = ((Error?) -> Void)?
    /// Info callback with success check and error for generic closures
    public typealias InfoCallback = ((Bool?, Error?) -> Void)?
    /// Success callback with generic response for closures
    public typealias ResponseCallback<T> = ((T) -> Void)?
}
