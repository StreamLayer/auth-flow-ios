//
//  ProfileFlowContext.swift
//  StreamLayer
//
//  Created by Kirill Kunst on 22.05.2023.
//

import Foundation
import SwiftUI
import Combine
import UIKit
import LetterAvatarKit

class ProfileFlowContext: ObservableObject {

  @Published var username: String = ""
  @Published var avatar: String = ""

  private var user: AuthUser
  private var profileProvider: ProfileProvider

  init(userData: AuthUser, profileProvider: ProfileProvider) {
    self.user = userData
    self.profileProvider = profileProvider
    self.username = userData.name ?? ""
    self.avatar = userData.avatar ?? ""
  }

  var avatarImage: UIImage {
    LetterAvatarMaker()
        .setUsername(username)
        .build() ?? UIImage()
  }

  static var mockUser: AuthUser {
    AuthUser.test()
  }

  @MainActor
  func updateAvatar(to image: UIImage) async {
    avatar = (try? await profileProvider.updateAvatar(to: image)) ?? ""
    user.avatar = avatar
    saveUser()
  }

  func deleteAvatar() {
    avatar = ""
    profileProvider.deleteAvatar()
    user.avatar = avatar
    saveUser()
  }

  func changeNameIfNeeded() async {
    if username != user.username {
      try? await profileProvider.setUserName(username)
      user.name = username
      saveUser()
    }
  }

  private func saveUser() {
    try? UserDefaults.standard.save(user, forKey: "UserData")
  }
}
