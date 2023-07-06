// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
  name: "SLRAuthFlow",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "SLRAuthFlow",
      targets: ["SLRAuthFlow"])
  ],
  dependencies: [
    .package(url: "https://github.com/MojtabaHs/iPhoneNumberField.git", from: "0.10.1"),
    .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.2.3"),
    .package(url: "https://github.com/vpeschenkov/LetterAvatarKit.git", from: "1.2.5")
  ],
  targets: [
    .target(
      name: "SLRAuthFlow",
      dependencies: [
        .product(name: "iPhoneNumberField", package: "iPhoneNumberField"),
        .product(name: "Introspect", package: "SwiftUI-Introspect"),
        .product(name: "LetterAvatarKit", package: "LetterAvatarKit")
      ], resources: [
        .process("Resources")
      ]),
    .testTarget(
      name: "SLRAuthFlowTests",
      dependencies: ["SLRAuthFlow"])
  ]
)
