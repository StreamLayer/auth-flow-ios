//
//  ProfileProvider.swift
//  
//
//  Created by Kirill Kunst on 06.06.2023.
//

import Foundation
import UIKit

public protocol ProfileProvider {
  func setUserName(_ name: String) async throws
  func updateAvatar(to image: UIImage) async throws -> String
  func deleteAvatar()
  func logout()
}

struct ProfileProviderMock: ProfileProvider {
  func setUserName(_ name: String) async throws {

  }

  func updateAvatar(to image: UIImage) async throws -> String {
    return ""
  }

  func deleteAvatar() {

  }

  func logout() {
  }
}
