//
//  Color+Custom.swift
//  
//
//  Created by Kirill Kunst on 25.04.2023.
//

import Foundation
import SwiftUI
import UIKit

extension Color {

  static var subtitle: Color {
    Color(red: 189 / 255, green: 189 / 255, blue: 189 / 255)
  }

  static var blueColor: Color {
    Color(red: 21 / 255, green: 137 / 255, blue: 238 / 255)
  }

  static var placeholder: Color {
    Color(red: 59 / 255, green: 62 / 255, blue: 66 / 255)
  }

  static var success: Color {
    Color(red: 0 / 255, green: 189 / 255, blue: 98 / 255)
  }

  static var wrong: Color {
    Color(red: 218 / 255, green: 55 / 255, blue: 50 / 255)
  }

  static var lightRed: Color {
    Color(red: 235 / 255, green: 87 / 255, blue: 87 / 255)
  }

}

extension UIColor {
  static var placeholder: UIColor {
    UIColor(red: 59 / 255, green: 62 / 255, blue: 66 / 255, alpha: 1.0)
  }

}
