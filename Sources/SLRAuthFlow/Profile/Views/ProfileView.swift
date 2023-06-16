//
//  ProfileView.swift
//  StreamLayer
//
//  Created by Kirill Kunst on 19.05.2023.
//

import Foundation
import SwiftUI

struct ProfileView: View {

  @Environment(\.presentationMode) var presentationMode

  @ObservedObject private var context: ProfileFlowContext
  private var onProfileEdit: () -> Void
  private var onTermsOfUseOpen: () -> Void
  private var onPrivacyPolicyOpen: () -> Void
  private var onLogout: () -> Void
  private var onBack: () -> Void

  init(context: ProfileFlowContext, onProfileEdit: @escaping () -> Void,
       onPrivacyPolicyOpen: @escaping () -> Void,
       onTermsOfUseOpen: @escaping () -> Void,
       onLogout: @escaping () -> Void,
       onBack: @escaping () -> Void) {
    self.context = context
    self.onProfileEdit = onProfileEdit
    self.onPrivacyPolicyOpen = onPrivacyPolicyOpen
    self.onTermsOfUseOpen = onTermsOfUseOpen
    self.onLogout = onLogout
    self.onBack = onBack
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
  }

  var body: some View {
    ZStack {
      ScrollView(.vertical) {
        VStack {
          userAvatarContainer
            .padding(.top, 30)
          userName
          profileButton(icon: "edit_icon", title: "Edit information", textColor: .white, showChevron: true) {
            onProfileEdit()
          }
          .padding(.top, 45)

          profileButton(icon: "shield_icon", title: "Privacy Policy", textColor: .white, showChevron: true) {
            onPrivacyPolicyOpen()
          }
          .padding(.top, 45)

          profileButton(icon: "shield_icon", title: "Terms of Use", textColor: .white, showChevron: true) {
            onTermsOfUseOpen()
          }
          .padding(.top, 12)

          profileButton(icon: "logout_icon", title: "Log out", textColor: .lightRed, showChevron: false) {
            onLogout()
          }
          .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .navigationTitle("Profile")
    .background(Color.black)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        backButton
      }
    }
  }

  var userAvatarContainer: some View {
    if !context.avatar.isEmpty {
      return AnyView(userAvatar)
    } else {
      return AnyView(placeholderAvatar)
    }
  }

  var userAvatar: some View {
    AsyncImage(url: URL(string: context.avatar)!) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)

    } placeholder: {
      placeholderAvatar
    }
    .frame(width: 122, height: 122)
    .clipShape(Circle())
  }

  var placeholderAvatar: some View {
    Image(uiImage: context.avatarImage)
      .resizable()
      .frame(width: 122, height: 122)
      .clipShape(Circle())
  }

  var userName: some View {
    Text(context.username)
      .font(Font.system(size: 24, weight: .semibold))
      .foregroundColor(Color.white)
      .padding([.top], 24)
      .padding([.horizontal], 50)
      .multilineTextAlignment(.center)
  }

  func profileButton(icon: String, title: String, textColor: Color, showChevron: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      HStack {
        Image(icon)
        Text(title)
          .foregroundColor(textColor)
          .padding(.leading, 12)
        Spacer()
        if showChevron {
          Image("icon_chevron_right", bundle: .module)
        }
      }
      .padding(.horizontal, 30)
    }
  }

  var backButton: some View {
    Button {
      onBack()
    } label: {
      Image("icon_chevron_left", bundle: .module)
    }
  }

}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(context: ProfileFlowContext(profileProvider: ProfileProviderMock())) {

    } onPrivacyPolicyOpen: {

    } onTermsOfUseOpen: {

    } onLogout: {

    } onBack: {

    }
  }
}
