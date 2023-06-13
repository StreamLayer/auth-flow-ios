//
//  SwiftUIView.swift
//  
//
//  Created by Kirill Kunst on 25.04.2023.
//

import SwiftUI

struct BlueButton: View {

  var title: String
  var isLoading: Bool
  var isDisabled: Bool
  var action: () -> Void

  var body: some View {
    Button(action: action) {
      if isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .white))
          .padding(.horizontal, 8)
          .frame(maxWidth: .infinity, maxHeight: 40)
      } else {
        Text(title)
          .padding(.horizontal, 8)
          .frame(maxWidth: .infinity, maxHeight: 40)
          .font(.system(size: 16, weight: .semibold))
      }
    }
    .disabled(isLoading || isDisabled)
    .buttonStyle(BlueButtonStyle(isDisabled: isLoading || isDisabled))

  }
}

struct BlueButton_Previews: PreviewProvider {
  static var previews: some View {
    BlueButton(title: "Next", isLoading: false, isDisabled: false, action: {

    })
  }
}
