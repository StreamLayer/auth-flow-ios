//
//  SwiftUIView.swift
//  
//
//  Created by Kirill Kunst on 25.04.2023.
//

import SwiftUI

struct OTPFieldView: View {
  enum FocusField: Hashable {
    case field
  }

  @ObservedObject var authFlowContext: AuthFlowContext
  @FocusState private var focusedField: FocusField?

  private var backgroundTextField: some View {
    return TextField("", text: $authFlowContext.pin.max(authFlowContext.otpCodeLength))
      .frame(width: 0, height: 0, alignment: .center)
      .font(Font.system(size: 0))
      .accentColor(.blue)
      .foregroundColor(.blue)
      .multilineTextAlignment(.center)
      .keyboardType(.numberPad)
      .autocorrectionDisabled(true)
      .onReceive(authFlowContext.$pin, perform: { _ in
        authFlowContext.limitText(authFlowContext.otpCodeLength)
      })
      .focused($focusedField, equals: .field)
      .task {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          self.focusedField = .field
        }
      }
      .padding()
  }

  public var body: some View {
    ZStack(alignment: .center) {
      backgroundTextField
      HStack {
        ForEach(0..<authFlowContext.otpCodeLength) { index in
          VStack {
            Text(authFlowContext.getPin(at: index))
              .font(Font.system(size: 26))
              .fontWeight(.semibold)
              .foregroundColor(Color.white)
              .frame(height: 50)
              .onTapGesture {
                self.focusedField = .field
              }
            Rectangle()
              .frame(height: 2)
              .foregroundColor(authFlowContext.codeInputsColor(for: index))
              .padding(.horizontal, 20)
          }
        }
      }
    }
  }
}

struct OTPFieldView_Previews: PreviewProvider {
  static var previews: some View {
    OTPFieldView(authFlowContext: AuthFlowContext.makeDefault())
  }
}
