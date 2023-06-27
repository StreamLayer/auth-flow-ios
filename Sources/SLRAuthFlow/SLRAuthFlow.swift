import UIKit
import SwiftUI

public class SLRAuthFlow {
  // Constants
  private struct Constants {
    static let otpCodeLength = 4
    static let countdownTimerSeconds = 60
  }
  
  private var handlers: [NavigationHander] = []
  
  // Instance Properties
  private var completionHandler: ((Error?) -> Void)?
  private weak var fromViewController: UIViewController?
  private let authProvider: AuthProvider
  private let navigationController: UINavigationController = {
    let navVC = UINavigationController()
    navVC.modalPresentationStyle = .fullScreen
    navVC.navigationBar.backgroundColor = .black
    navVC.navigationBar.tintColor = .black
    navVC.navigationBar.isTranslucent = false
    return navVC
  }()
  
  // Initializer
  public init(authProvider: AuthProvider) {
    self.authProvider = authProvider
  }
  
  // Public Methods
  /// Show authentication flow from a view controller.
  public func show(from viewController: UIViewController, completion: @escaping (Error?) -> Void) {
    completionHandler = completion
    let authContext = AuthFlowContext(otpCodeLength: Constants.otpCodeLength,
                                      countdownTimerSeconds: Constants.countdownTimerSeconds,
                                      authProvider: authProvider)
    
    let onNext: BoolClosure = { _ in
      self.showOTP(authInput: authContext)
    }
    
    let onBack: RegularClosure = {
      viewController.dismiss(animated: true)
    }
    
    let vc = UIHostingController(rootView: PhoneInputView(authFlowContext: authContext).environment(\.regularClosure, onBack).environment(\.boolClosure, onNext))
    navigationController.setViewControllers([vc], animated: false)
    fromViewController = viewController
    viewController.present(navigationController, animated: true)
  }
  
  // Private Methods
  private func showOTP(authInput: AuthFlowContext) {
    let onNext: BoolClosure = { shouldClose in
      if shouldClose {
        self.fromViewController?.presentedViewController?.dismiss(animated: true)
        self.completionHandler?(nil)
      } else {
        self.showNameInput(authInput: authInput)
      }
    }
    
    let onBack: RegularClosure = {
      self.navigationController.popViewController(animated: true)
    }
    
    let vc = UIHostingController(rootView: OTPInputView(authFlowContext: authInput).environment(\.regularClosure, onBack).environment(\.boolClosure, onNext))
    navigationController.pushViewController(vc, animated: true)
  }
  
  private func showNameInput(authInput: AuthFlowContext) {
    let onNext: BoolClosure = { shouldClose in
      if shouldClose {
        self.fromViewController?.presentedViewController?.dismiss(animated: true)
        self.completionHandler?(nil)
      }
    }
    
    let onBack: RegularClosure = {
      self.fromViewController?.presentedViewController?.dismiss(animated: true)
    }
    
    let vc = UIHostingController(rootView: NameInputView(authFlowContext: authInput).environment(\.regularClosure, onBack).environment(\.boolClosure, onNext))
    navigationController.pushViewController(vc, animated: true)
  }
}
