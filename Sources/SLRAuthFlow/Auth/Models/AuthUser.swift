//
//  AuthUser.swift
//  
//
//  Created by Kirill Kunst on 06.06.2023.
//

import Foundation

public class AuthUser: Codable {
  public var id: String
  public var username: String
  public var name: String?
  public var avatar: String?
  public var alias: String?

  public init(id: String, username: String, name: String?, avatar: String?, alias: String?) {
    self.id = id
    self.username = username
    self.name = name
    self.avatar = avatar
    self.alias = alias
  }

  public static func test() -> AuthUser {
    AuthUser(id: "1", username: "ivanova", name: "Mary Ivanova", avatar: "", alias: "Mary Ivanova")
  }

  public var isNameEmpty: Bool {
    let alias = self.alias ?? ""
    let name = self.name ?? ""
    return alias.isEmpty && name.isEmpty && username.isEmpty
  }
}
