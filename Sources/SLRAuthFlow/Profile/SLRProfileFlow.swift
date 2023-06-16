//
//  ProfileFlow.swift
//  StreamLayer
//
//  Created by Kirill Kunst on 19.05.2023.
//

import Foundation
import UIKit
import SwiftUI

public class SLRProfileFlow {
  private weak var fromViewController: UIViewController?
  private let navigationController: UINavigationController = {
    let navVC = UINavigationController()
    navVC.modalPresentationStyle = .fullScreen
    navVC.navigationBar.backgroundColor = .black
    navVC.navigationBar.tintColor = .black
    navVC.navigationBar.isTranslucent = false
    return navVC
  }()
  private let profileProvider: ProfileProvider

  // Initializer
  public init(profileProvider: ProfileProvider) {
    self.profileProvider = profileProvider
  }

  public func show(from viewController: UIViewController) {
    guard profileProvider.user() != nil else {
      return
    }

    let context = ProfileFlowContext(profileProvider: profileProvider)
    let vc = UIHostingController(rootView: ProfileView(context: context, onProfileEdit: {
      self.openProfileInfo(context: context)
    }, onPrivacyPolicyOpen: {
      self.openPrivacyPolicy()
    }, onTermsOfUseOpen: {
      self.openTermsOfUse()
    }, onLogout: {
      self.logout()
    }, onBack: {
      self.fromViewController?.dismiss(animated: true)
    }))
    navigationController.setViewControllers([vc], animated: false)
    fromViewController = viewController
    viewController.present(navigationController, animated: true)
  }

  private func openProfileInfo(context: ProfileFlowContext) {
    let vc = UIHostingController(rootView: EditProfileView(context: context, onBack: {
      self.navigationController.popViewController(animated: true)
    }))
    navigationController.pushViewController(vc, animated: true)
  }

  private func openPrivacyPolicy() {
    let vc = UIHostingController(rootView: TextPageView(title: "Privacy Policy", text: String.dummyLoremIpsum, onBack: {
      self.navigationController.popViewController(animated: true)
    }))
    navigationController.pushViewController(vc, animated: true)
  }

  private func openTermsOfUse() {
    let vc = UIHostingController(rootView: TextPageView(title: "Terms of Use", text: String.dummyLoremIpsum, onBack: {
      self.navigationController.popViewController(animated: true)
    }))
    navigationController.pushViewController(vc, animated: true)
  }

  private func logout() {
    UserDefaults.standard.removeObject(forKey: "UserData")
    profileProvider.logout()
    fromViewController?.dismiss(animated: true)
  }
}
