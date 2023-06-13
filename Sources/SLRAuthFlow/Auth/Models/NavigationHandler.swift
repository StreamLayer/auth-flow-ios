//
//  NavigationHander.swift
//  
//
//  Created by Kirill Kunst on 12.05.2023.
//

import Foundation

protocol NavigationHander: AnyObject {
  func onNext(_ shouldClose: Bool)
  func onPrevious()
}

final class AuthFlowNavigationHandler {
  var onNextAction: ((Bool) -> Void)?
  var onPreviousAction: (() -> Void)?

  init(onNextAction: ((Bool) -> Void)?, onPreviousAction: (() -> Void)?) {
    self.onNextAction = onNextAction
    self.onPreviousAction = onPreviousAction
  }

  static func makeEmpty() -> AuthFlowNavigationHandler {
    return .init(onNextAction: nil, onPreviousAction: nil)
  }
}

extension AuthFlowNavigationHandler: NavigationHander {
  func onNext(_ shouldClose: Bool) {
    onNextAction?(shouldClose)
  }

  func onPrevious() {
    onPreviousAction?()
  }
}
