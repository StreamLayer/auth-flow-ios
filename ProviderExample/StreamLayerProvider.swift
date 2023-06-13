//
//  SLRAuthProviderWrapper.swift
//  StreamLayer
//
//

import Foundation
import SLRAuthFlow
import StreamLayer
import UIKit

public class StreamLayerProvider: AuthProvider, ProfileProvider {

  public func requestOTP(phoneNumber: String) async throws {
    try await StreamLayer.Auth.requestOTP(phoneNumber: phoneNumber)
  }

  public func authenticate(phoneNumber: String, code: String) async throws -> AuthUser {
    let authData = try await StreamLayer.Auth.authenticate(phoneNumber: phoneNumber, code: code)
    let user = AuthUser(id: authData.user.id,
                        username: authData.user.username,
                        name: authData.user.name,
                        avatar: authData.user.avatar,
                        alias: authData.user.alias)
    try await StreamLayer.setAuthorizationBypass(token: authData.jwtToken, schema: AppConfiguration.shared.bypassScheme)
    return user
  }

  public func setUserName(_ name: String) async throws {
    try await StreamLayer.Auth.setUserName(name)
  }

  public func updateAvatar(to image: UIImage) async throws -> String {
    try await StreamLayer.Auth.uploadAvatar(image)
  }

  public func deleteAvatar() {
    StreamLayer.Auth.deleteAvatar()
  }

  public func logout() {
    StreamLayer.logout()
  }

}
