//
//  ACMGenericCallbacks.swift
//

public enum ACMGenericCallbacks {
    public typealias VoidCallback = (() -> Void)?
    public typealias ErrorCallback = ((Error?) -> Void)?
    public typealias InfoCallback = ((Bool?, Error?) -> Void)?
}
