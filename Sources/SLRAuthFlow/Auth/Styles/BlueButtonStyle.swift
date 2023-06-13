//
//  File.swift
//  
//
//  Created by Kirill Kunst on 25.04.2023.
//

import Foundation
import SwiftUI

struct BlueButtonStyle: ButtonStyle {

  var isDisabled = false

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(.white)
      .background(configuration.isPressed || isDisabled ? Color.blueColor.opacity(0.8) : Color.blueColor)
      .cornerRadius(6.0)
  }

}
