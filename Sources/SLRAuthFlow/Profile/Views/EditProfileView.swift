//
//  EditProfileView.swift
//  StreamLayer
//
//  Created by Kirill Kunst on 19.05.2023.
//

import Foundation
import SwiftUI

struct EditProfileView: View {

  @State var showMediaPicker: Bool = false
  @State var showMediaDialog: Bool = false
  @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
  @ObservedObject private var context: ProfileFlowContext
  private var onBack: () -> Void

  init(context: ProfileFlowContext, onBack: @escaping () -> Void) {
    self.context = context
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
            .onTapGesture {
              showMediaDialog.toggle()
            }
          userName
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .navigationTitle("Edit information")
    .background(Color.black)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        backButton
      }
    }
    .confirmationDialog("", isPresented: $showMediaDialog, titleVisibility: .hidden) {
      Button("Open Photo") {
        self.sourceType = .photoLibrary
        showMediaPicker.toggle()
      }
      Button("Take Photo") {
        self.sourceType = .camera
        showMediaPicker.toggle()
      }
      Button("Delete photo", role: .destructive) {
        context.deleteAvatar()
      }
    }
    .sheet(isPresented: $showMediaPicker) {
      ImagePicker(sourceType: sourceType, selectedImage: $context.selectedImage)
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
    ZStack {
      TextField("Enter name...", text: $context.username)
        .foregroundColor(.white)
        .font(.system(size: 14.0, weight: .semibold))
        .padding()
        .padding(.horizontal, 16)
        .textFieldStyle(PlainTextFieldStyle())
        .overlay(
          RoundedRectangle(cornerRadius: 5)
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            .frame(height: 40)
            .padding(.horizontal, 16)
        )
        .frame(height: 40)
        .padding(.top, 40)
    }
  }

  var backButton: some View {
    Button {
      Task {
        await context.changeNameIfNeeded()
      }
      onBack()
    } label: {
      Image("icon_chevron_left", bundle: .module)
    }
  }

}

struct EditProfileView_Previews: PreviewProvider {
  static var previews: some View {
    EditProfileView(context: ProfileFlowContext(profileProvider: ProfileProviderMock()), onBack: {

    })
  }
}
