//
//  NameInputView.swift
//  
//
//  Created by Kirill Kunst on 04.05.2023.
//

import Foundation
import SwiftUI

struct NameInputView: View {

  @FocusState private var nameFieldIsFocused: Bool
  @ObservedObject var authFlowContext: AuthFlowContext
  @Environment(\.regularClosure) var onBack
  @Environment(\.boolClosure) var onNext

  init(authFlowContext: AuthFlowContext) {
    self.authFlowContext = authFlowContext
    self.nameFieldIsFocused = true
    UITextField.appearance().keyboardAppearance = .dark
  }

  var body: some View {
    ZStack {
      ScrollView(.vertical) {
        VStack {
          titleView
          HStack {
            Spacer()
            nameInput
              .padding(.top, 46)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      VStack {
        Spacer()
        nextButton
      }
    }
    .navigationTitle("Profile")
    .background(Color.black)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        backButton
      }
    }
  }

  var titleView: some View {
    VStack {
      Image("streamlayer_logo", bundle: .module)
      titleText
      subtitleText
    }
    .padding([.top], 70)
  }

  var titleText: some View {
    Text("Enter Your Name")
      .font(Font.system(size: 24, weight: .semibold))
      .foregroundColor(Color.white)
      .padding([.top], 24)
      .padding([.horizontal], 50)
      .multilineTextAlignment(.center)
  }

  var subtitleText: some View {
    Text("Please enter your name \n so friends will recognize you")
      .font(Font.system(size: 14, weight: .regular))
      .foregroundColor(Color.subtitle)
      .padding([.top], 1)
      .padding([.horizontal], 80)
      .multilineTextAlignment(.center)
  }

  var nameInput: some View {
    TextField(
      "",
      text: $authFlowContext.userName
    )
    .focused($nameFieldIsFocused)
    .onSubmit {

    }
    .multilineTextAlignment(.center)
    .textInputAutocapitalization(.never)
    .disableAutocorrection(true)
    .font(.system(size: 24, weight: .semibold))
    .foregroundColor(Color.white)
    .placeHolder(namePlaceholder, show: authFlowContext.userName.isEmpty)
  }

  var namePlaceholder: some View {
    HStack {
      Spacer()
      Text("Your Name")
        .multilineTextAlignment(.center)
        .foregroundColor(Color.placeholder)
        .font(.system(size: 24, weight: .semibold))
      Spacer()
    }
  }

  var nextButton: some View {
    BlueButton(title: "Next", isLoading: false, isDisabled: false) {
      Task {
        await self.authFlowContext.sendUpdatedName()
        await MainActor.run {
          self.onNext?(true)
        }
      }
    }
    .padding(.horizontal, 16)
    .frame(minHeight: 40)
  }

  var backButton: some View {
    Button {
      self.onBack?()
    } label: {
      Image("icon_chevron_left", bundle: .module)
    }
  }

}

struct NameInputView_Previews: PreviewProvider {
  static var previews: some View {
    NameInputView(authFlowContext: AuthFlowContext.makeDefault())
  }
}
