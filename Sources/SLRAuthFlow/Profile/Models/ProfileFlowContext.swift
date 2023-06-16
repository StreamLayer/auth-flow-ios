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

  init(profileProvider: ProfileProvider) {
    self.user = profileProvider.user()!
    self.profileProvider = profileProvider
    self.username = user.name ?? ""
    self.avatar = user.avatar ?? ""
  }

  var avatarImage: UIImage {
    LetterAvatarMaker()
        .setUsername(username)
        .build() ?? UIImage()
  }

  @MainActor
  func updateAvatar(to image: UIImage) async {
    avatar = (try? await profileProvider.updateAvatar(to: image)) ?? ""
    user.avatar = avatar
  }

  func deleteAvatar() {
    avatar = ""
    profileProvider.deleteAvatar()
    user.avatar = avatar
  }

  func changeNameIfNeeded() async {
    if username != user.username {
      try? await profileProvider.setUserName(username)
      user.name = username
    }
  }
}
