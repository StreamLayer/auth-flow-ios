//
//  PhoneNumber+Custom.swift
//  
//
//  Created by Kirill Kunst on 16.05.2023.
//

import Foundation
import iPhoneNumberField
import PhoneNumberKit

extension PhoneNumber {

  var plainWithCountryCode: String {
    "\(countryCode)\("\(nationalNumber)".replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: ""))"
  }

  var isValid: Bool {
    (try? PhoneNumberKit().parse(numberString)) != nil
  }

}
