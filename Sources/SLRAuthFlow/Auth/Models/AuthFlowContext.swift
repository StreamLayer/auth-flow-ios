//
//  AuthFlowContext.swift
//  
//
//  Created by Kirill Kunst on 25.04.2023.
//

import Foundation
import Combine
import SwiftUI
import PhoneNumberKit

class AuthFlowContext: ObservableObject {

  enum PinState {
    case undefined
    case successful
    case wrong
  }

  struct State {
    var isLoading: Bool = false
    var isPhoneNumberValid: Bool = false
    var pinState: PinState = .undefined
    var shouldShowNameInput: Bool = false
    var error: Error?

    mutating func change(_ transform: (inout Self) -> Void) {
      transform(&self)
    }
  }

  struct Constants {
    static let countdownTimerLength: Int = 60
    static let otpCodeLength: Int = 4
  }

  // MARK: - Published

  @Published var state: State = .init()

  @Published var pin: String = ""
  @Published var phoneNumber = ""
  @Published var userName: String = ""
  @Published var timerExpired = false
  @Published var time = ""
  @Published var timeRemaining = Constants.countdownTimerLength

  private var bag = Set<AnyCancellable>()

  // MARK: Regular

  var phoneNumberFormatted: String = ""
  var codeSent: Bool = false
  var authSent: Bool = false
  var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  var nowDate = Date()
  var countdownTimerSeconds: Int
  var otpCodeLength: Int

  private var authProvider: AuthProvider

  init(otpCodeLength: Int, countdownTimerSeconds: Int, authProvider: AuthProvider) {
    self.otpCodeLength = otpCodeLength
    self.countdownTimerSeconds = countdownTimerSeconds
    self.authProvider = authProvider

    $pin.removeDuplicates().sink { [unowned self] pin in
      Task {
        await self.sendCodeIfNeeded(pin: pin)
      }
    }.store(in: &bag)
  }

  static func makeDefault() -> AuthFlowContext {
    return AuthFlowContext(otpCodeLength: 4, countdownTimerSeconds: 60, authProvider: AuthProviderMock())
  }

  // MARK: - Timer actions

  func startTimer() {
    timerExpired = false
    timeRemaining = countdownTimerSeconds
    self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  }

  func stopTimer() {
    timerExpired = true
    self.timer.upstream.connect().cancel()
  }

  func countDownString() {
    guard timeRemaining > 0 else {
      self.timer.upstream.connect().cancel()
      timerExpired = true
      time = ""
      return
    }

    timeRemaining -= 1
    time = "\(timeRemaining)"
  }

  func getPin(at index: Int) -> String {
    guard self.pin.count > index else {
      return ""
    }

    return self.pin[index..<(index + 1)]
  }

  func limitText(_ upper: Int) {
    if pin.count > upper {
      pin = String(pin.prefix(upper))
    }
  }

  // MARK: - Colors

  func codeInputsColor(for index: Int) -> Color {
    switch state.pinState {
    case .successful:
      return Color.success
    case .wrong:
      return Color.wrong
    case .undefined:
      return index < pin.count ? Color.blue : Color.subtitle
    }
  }

}

// MARK: - Actions
extension AuthFlowContext {

  func phoneNumberChanged(to phoneNumber: PhoneNumber?) {
    self.phoneNumber = phoneNumber?.plainWithCountryCode ?? ""
    self.phoneNumberFormatted = phoneNumber?.numberString ?? ""
    self.state.isPhoneNumberValid = phoneNumber?.isValid ?? false
  }

  @MainActor
  func resendCode() async {
    codeSent = false
    authSent = false
    timerExpired = false
    time = ""
    await requestOTP()
  }

  @MainActor
  // Send OTP if it hasn't been sent and the pin is complete
  func sendCodeIfNeeded(pin: String) async {
    guard pin.count == otpCodeLength, !codeSent else {
      codeSent = false
      state.change {
        $0.pinState = .undefined
      }
      return
    }
    codeSent = true
    state.change { $0.isLoading = true }

    do {
      let user = try await authProvider.authenticate(phoneNumber: phoneNumber, code: pin)
      try UserDefaults.standard.save(user, forKey: "UserData")
      let shouldShowNameInput = user.isNameEmpty
      stopTimer()
      state.change {
        $0.isLoading = false
        $0.shouldShowNameInput = shouldShowNameInput
        $0.pinState = .successful
      }
    } catch {
      codeSent = false
      state.change {
        $0.isLoading = false
        $0.pinState = .wrong
        $0.error = error
      }
    }
  }

  @MainActor
  // Request OTP if it hasn't been requested
  func requestOTP() async {
    guard !authSent else { return }
    authSent = true
    state.change { $0.isLoading = true }

    do {
      _ = try await authProvider.requestOTP(phoneNumber: phoneNumber)
      state.change { $0.isLoading = false }
      startTimer()
    } catch {
      authSent = false
      state.change {
        $0.isLoading = false
        $0.error = error
      }
    }
  }

  @MainActor
  // Request OTP if it hasn't been requested
  func sendUpdatedName() async {
    state.change { $0.isLoading = true }
    do {
      try await authProvider.setUserName(userName)
      state.change { $0.isLoading = false }
    } catch {
      state.change {
        $0.isLoading = false
        $0.error = error
      }
    }
  }

}
