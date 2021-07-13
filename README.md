# InTarget
InTarget is using SPM, Firebase, CoreData, Localizable , Local Notification, UnitTest and UITest with Test Plan

# Run an XCTest in Firebase
xcodebuild -project /Users/brunolemgruber/XcodeProjects/RayWenderlich_projects/InTarget/InTarget.xcodeproj \
-scheme InTarget \
-derivedDataPath /Users/brunolemgruber/XcodeProjects/RayWenderlich_projects/InTarget/ \
-sdk iphoneos build-for-testing

# Run an XCTest Locally
xcodebuild test-without-building \
    -xctestrun /Users/brunolemgruber/XcodeProjects/RayWenderlich_projects/InTarget/Build/Products/InTarget_InTarget_iphoneos14.5-arm64.xctestrun \
    -destination id=5e3a5492a56932753976bf2b6acd0f8abc730497
