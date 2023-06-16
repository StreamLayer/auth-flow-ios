//
//  AuthProvider.swift
//  
//
//  Created by Kirill Kunst on 12.05.2023.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

public protocol AuthProvider {
  func requestOTP(phoneNumber: String) async throws
  func authenticate(phoneNumber: String, code: String) async throws -> AuthUser
  func setUserName(_ name: String) async throws
}

public class AuthProviderMock: AuthProvider {
  
  public init() {}

  public func requestOTP(phoneNumber: String) async throws {
    print("[AuthProvider] requestOTP(phoneNumber:)")
    try await Task.sleep(seconds: 2.0)
  }

  public func authenticate(phoneNumber: String, code: String) async throws -> AuthUser {
    print("[AuthProvider] authenticate(phoneNumber:)")
    try await Task.sleep(seconds: 2.0)
    return AuthUser.test()
  }

  public func setUserName(_ name: String) async throws {
    print("[AuthProvider] setUserName(:)")
    try await Task.sleep(seconds: 2.0)
  }

}
