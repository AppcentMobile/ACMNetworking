//
//  ACMBaseResult.swift
//

public enum ACMBaseResult<T, E> where E: Error {
    case success(T)
    case failure(E)
}
