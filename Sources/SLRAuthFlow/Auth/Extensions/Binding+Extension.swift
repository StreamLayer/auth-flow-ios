//
//  Binding+Extension.swift
//  
//
//  Created by Kirill Kunst on 22.05.2023.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
  func max(_ limit: Int) -> Self {
    if self.wrappedValue.count > limit {
      DispatchQueue.main.async {
        self.wrappedValue = String(self.wrappedValue.dropLast())
      }
    }
    return self
  }
}
