//
//  UserDefaults+Custom.swift
//  StreamLayer
//
//  Created by Kirill Kunst on 23.05.2023.
//

import Foundation

extension UserDefaults {

  func save<T: Codable>(_ object: T, forKey: String) throws {
    let jsonData = try JSONEncoder().encode(object)
    set(jsonData, forKey: forKey)
  }

  public func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
    guard let result = value(forKey: forKey) as? Data else {
      return nil
    }
    return try JSONDecoder().decode(objectType, from: result)
  }

}
