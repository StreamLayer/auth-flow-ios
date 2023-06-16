//
//  ProfileProvider.swift
//  
//
//  Created by Kirill Kunst on 06.06.2023.
//

import Foundation
import UIKit

public protocol ProfileProvider {
  func user() -> AuthUser?
  func setUserName(_ name: String) async throws
  func updateAvatar(to image: UIImage) async throws -> String
  func deleteAvatar()
  func logout()
}

public struct ProfileProviderMock: ProfileProvider {
  
  public init() {}
  
  public func user() -> AuthUser? {
    return AuthUser.test()
  }
  
  public func setUserName(_ name: String) async throws {

  }

  public func updateAvatar(to image: UIImage) async throws -> String {
    return ""
  }

  public func deleteAvatar() {

  }

  public func logout() {
  }
}
