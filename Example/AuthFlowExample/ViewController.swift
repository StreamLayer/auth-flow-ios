//
//  ViewController.swift
//  AuthFlowExample
//
//  Created by Kirill Kunst on 02.05.2023.
//

import UIKit
import SLRAuthFlow

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func showAuth(_ sender: Any) {
    let provider = AuthProviderMock()
    SLRAuthFlow(authProvider: provider).show(from: self) { err in
      
    }
  }
  
  @IBAction func showProfile(_ sender: Any) {
    SLRProfileFlow(profileProvider: ProfileProviderMock()).show(from: self)
  }
  
}

