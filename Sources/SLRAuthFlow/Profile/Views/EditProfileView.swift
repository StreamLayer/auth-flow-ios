//
//  EditProfileView.swift
//  StreamLayer
//
//  Created by Kirill Kunst on 19.05.2023.
//

import Foundation
import SwiftUI
import ExyteMediaPicker

struct EditProfileView: View {

  @State var showMediaPicker: Bool = false
  @State var showMediaDialog: Bool = false

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
              showMediaPicker.toggle()
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
    .confirmationDialog("", isPresented: $showMediaDialog, titleVisibility: .visible) {
      Button("Open Photo") {
        showMediaPicker.toggle()
      }
      Button("Delete photo") {
        context.deleteAvatar()
      }
    }
    .sheet(isPresented: $showMediaPicker) {
      MediaPicker(isPresented: $showMediaPicker) { medias in
        Task {
          guard let imageData = await medias.first?.getData(),
                let image = UIImage(data: imageData) else {
            return
          }
          await context.updateAvatar(to: image)
        }
      }
      .mediaSelectionType(.photo)
      .mediaSelectionLimit(1)
      .showLiveCameraCell()
      .mediaPickerTheme(
        main: .init(
          albumSelectionBackground: Color.black,
          cameraBackground: Color.black,
          cameraSelectionBackground: Color.black
        ),
        selection: .init(
          emptyTint: .white,
          emptyBackground: .black.opacity(0.25),
          selectedTint: Color.white
        )
      )

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
    EditProfileView(context: ProfileFlowContext(userData: ProfileFlowContext.mockUser, profileProvider: ProfileProviderMock()), onBack: {

    })
  }
}
