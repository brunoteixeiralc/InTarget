# InTarget
InTarget is using SPM, Cocoapods, Lottie, MessageKit, Firebase, CoreData, Localizable , Local Notification, UnitTest and UITest with Test Plan

# SPM and Cocoapods
Using both because the lib MessageKit (3.6.0), Lottie (not find de url) is not working well with SPM

Using XCTest, iPhone 7 Plus, iOS 14.1

# Run an XCTest in Firebase
xcodebuild -project /Users/brunolemgruber/XcodeProjects/RayWenderlich_projects/InTarget/InTarget.xcodeproj \
-scheme InTarget \
-derivedDataPath /Users/brunolemgruber/XcodeProjects/RayWenderlich_projects/InTarget/ \
-sdk iphoneos build-for-testing

# Run an XCTest Locally
xcodebuild test-without-building \
    -xctestrun /Users/brunolemgruber/XcodeProjects/RayWenderlich_projects/InTarget/Build/Products/InTarget_InTarget_iphoneos14.5-arm64.xctestrun \
    -destination id=5e3a5492a56932753976bf2b6acd0f8abc730497
