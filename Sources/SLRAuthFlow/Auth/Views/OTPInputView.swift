//
//  SwiftUIView.swift
//  
//
//  Created by Kirill Kunst on 25.04.2023.
//

import SwiftUI

struct OTPInputView: View {
  @State var text: String = ""
  @State var isEditing: Bool = false
  @State var navigationPerformed: Bool = false

  @ObservedObject var authFlowContext: AuthFlowContext
  @Environment(\.regularClosure) var onBack
  @Environment(\.boolClosure) var onNext

  init(authFlowContext: AuthFlowContext) {
    self.authFlowContext = authFlowContext
    UITextField.appearance().keyboardAppearance = .dark
  }

  var body: some View {
    ZStack {
      ScrollView(.vertical) {
        VStack {
          titleView
          HStack {
            Spacer()
            otpInput
              .padding(.top, 45)
            Spacer()
          }
          activityIndicator
        }
      }
      VStack {
        Spacer()
        resendContainer
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationTitle("Profile")
    .background(Color.black)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        backButton
      }
    }
    .onReceive(authFlowContext.$state, perform: { state in
      if state.pinState == .successful, navigationPerformed == false {
        authFlowContext.state.pinState = .undefined
        self.navigationPerformed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.onNext?(!state.shouldShowNameInput)
        }
      }
    })
    .onReceive(authFlowContext.timer) { _ in
      authFlowContext.countDownString()
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
    Text("Enter Verification Code")
      .font(Font.system(size: 24, weight: .semibold))
      .foregroundColor(Color.white)
      .padding([.top], 24)
      .padding([.horizontal], 50)
      .multilineTextAlignment(.center)
  }

  var subtitleText: some View {
    Text("Please enter the verification code sent to \(authFlowContext.phoneNumberFormatted)")
      .font(Font.system(size: 14, weight: .regular))
      .foregroundColor(Color.subtitle)
      .padding([.top], 1)
      .padding([.horizontal], 80)
      .multilineTextAlignment(.center)
  }

  var otpInput: some View {
    OTPFieldView(authFlowContext: authFlowContext)
      .padding(.horizontal, 50)
  }

  var activityIndicator: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle(tint: .white))
      .padding(.horizontal, 8)
      .padding(.top, 20)
      .opacity(authFlowContext.state.isLoading ? 1.0 : 0.0)
  }

  var backButton: some View {
    Button {
      authFlowContext.authSent = false
      self.onBack?()
    } label: {
      Image("icon_chevron_left", bundle: .module)
    }
  }

  var resendContainer: some View {
    if authFlowContext.authSent {
      if authFlowContext.timerExpired {
        return AnyView(HStack {
          Text("Didn't get a code?")
            .font(.system(size: 14))
            .foregroundColor(.white)
            .padding([.horizontal], 20)
            .multilineTextAlignment(.center)
          Button("Resend") {
            Task {
              await authFlowContext.resendCode()
            }
          }
          .font(.system(size: 15, weight: .bold))
          .foregroundColor(.white)
          .frame(height: 40)
        })
      } else {
        return AnyView(HStack {
          Text("Didn't get a code? Resend Code in \(authFlowContext.time)")
            .foregroundColor(Color.white)
            .font(.system(size: 14))
            .padding([.horizontal], 20)
            .multilineTextAlignment(.center)
        }
          .frame(height: 40))

      }
    } else {
      return AnyView(Spacer())
    }
  }

}

struct OTPInputView_Previews: PreviewProvider {
  static var previews: some View {
    OTPInputView(authFlowContext: AuthFlowContext.makeDefault())
  }
}
