# SLRAuthFlow

`SLRAuthFlow` is a module designed to handle the authentication flow in an iOS application. This class uses a combination of SwiftUI `UIHostingController` and UIKit's `UINavigationController` to present an authentication process consisting of phone number input, OTP (One-Time Password) verification, and name input stages.

## Installation

Assuming the `SLRAuthFlow` is part of your project source code, simply import it wherever you need to use it.

```swift
import SLRAuthFlow
```
If the class is part of a custom module or package, the import statement should reflect that.


## Usage

### Initialization
To create an instance of `SLRAuthFlow`, you need to pass an `AuthProvider` instance to its initializer. `AuthProvider` is a custom protocol or class that the authentication flow uses to perform authentication operations.

```swift
let authProvider = YourAuthProvider()
let authFlow = SLRAuthFlow(authProvider: authProvider)
```

### Showing the Authentication Flow
To start the authentication flow, call the `show(from:completion:)` method. Pass the view controller you want to present the authentication flow from and a completion closure that takes an optional `Error` argument.

```swift
authFlow.show(from: self) { error in
  if let error = error {
    // Handle error
    print(error)
  } else {
    // Authentication flow completed successfully
  }
}
```

The `show(from:completion:)` method will present a modal `UINavigationController` that manages the authentication flow. The flow is split into stages, each represented by a different view:

* Phone number input (PhoneInputView)
* OTP verification (OTPInputView)
* Name input (NameInputView)

Navigation between these stages and error handling is managed internally by SLRAuthFlow.

# SLRProfileFlow

`SLRProfileFlow` is a module designed to manage the user profile flow in an iOS application. The class utilizes both SwiftUI's `UIHostingController` and UIKit's `UINavigationController` to present a series of views for profile display, profile editing, privacy policy, terms of use, and logout functionalities.


## Installation

Assuming the `SLRProfileFlow` is part of your project source code, you should import it in the location where you wish to utilize it.

```swift
import SLRAuthFlow
```

If the class is part of a separate module or package, adjust your import statement accordingly.

## Usage

### Initialization

To initialize an instance of `SLRProfileFlow`, you must provide an instance of `ProfileProvider` to the initializer. `ProfileProvider` is a custom protocol or class responsible for providing user profile data and managing profile updates.

```swift
let profileProvider = YourProfileProvider()
let profileFlow = SLRProfileFlow(profileProvider: profileProvider)
```

### Showing the Profile Flow

To present the profile flow, call the `show(from:)` method, passing in the view controller from which you want to present the profile flow.

```swift
profileFlow.show(from: self)
```

The `show(from:)` method presents a `UINavigationController` instance that manages the following views in the profile flow:

1. `ProfileView`: Display the user's profile.
2. `EditProfileView`: Provide an interface to edit the user's profile information.
3. `TextPageView`: Display text content such as Privacy Policy and Terms of Use.

Navigation between these stages is handled internally by `SLRProfileFlow`.

