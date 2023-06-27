//
//  File.swift
//  
//
//  Created by Kirill Kunst on 27.06.2023.
//

import Foundation
import SwiftUI

typealias RegularClosure = (() -> Void)?
typealias BoolClosure = ((Bool) -> Void)?

struct RegularClosureKey: EnvironmentKey {
  static let defaultValue : RegularClosure = { }
}

struct BoolClosureKey: EnvironmentKey {
  static let defaultValue : BoolClosure = { _ in }
}

struct AuthFlowContextKey: EnvironmentKey {
  static let defaultValue : AuthFlowContext = AuthFlowContext(otpCodeLength: 4, countdownTimerSeconds: 4, authProvider: AuthProviderMock())
}

struct ProfileFlowContextKey: EnvironmentKey {
  static let defaultValue : ProfileFlowContext = ProfileFlowContext(profileProvider: ProfileProviderMock())
}

extension EnvironmentValues {
  var regularClosure : RegularClosure {
    get { self[RegularClosureKey.self] }
    set { self[RegularClosureKey.self] = newValue }
  }
  
  var boolClosure : BoolClosure {
    get { self[BoolClosureKey.self] }
    set { self[BoolClosureKey.self] = newValue }
  }
  
  var authFlowContext : AuthFlowContext {
    get { self[AuthFlowContextKey.self] }
    set { self[AuthFlowContextKey.self] = newValue }
  }
  
  var profileFlowContext : ProfileFlowContext {
    get { self[ProfileFlowContextKey.self] }
    set { self[ProfileFlowContextKey.self] = newValue }
  }
}
