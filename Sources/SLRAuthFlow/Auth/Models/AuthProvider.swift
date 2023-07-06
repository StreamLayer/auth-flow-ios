//
//  AuthProvider.swift
//  
//
//  Created by Kirill Kunst on 12.05.2023.
//

import Foundation

enum TestError: Error {
  case testError
}

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
    try await Task.sleep(seconds: 1.0)
  }

  public func authenticate(phoneNumber: String, code: String) async throws -> AuthUser {
    print("[AuthProvider] authenticate(phoneNumber:)")
    if code != "1111" {
      throw TestError.testError
    }
    try await Task.sleep(seconds: 1.0)
    
    return AuthUser.test()
  }

  public func setUserName(_ name: String) async throws {
    print("[AuthProvider] setUserName(:)")
    try await Task.sleep(seconds: 1.0)
  }

}
