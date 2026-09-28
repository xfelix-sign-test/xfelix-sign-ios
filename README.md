# xFelix Sign – iOS App

This project wraps the existing xfelix-sign.de website in a native iOS/iPadOS shell using WKWebView.

## Included website functionality
- UDID / Apple device enrollment
- Free signing with IPA + .p12 + provisioning profile
- Admin login
- Admin Development / Distribution signing
- Signed IPA download
- iOS installation links (`itms-services://`) opened outside WKWebView
- iPhone + iPad portrait/landscape support

## Before building
1. Open the project on a Mac with Xcode.
2. In the target's Signing & Capabilities section, enable Automatically manage signing.
3. Select your Apple Developer Team.
4. Change the Bundle Identifier if `de.xfelix.sign` is not available for your team.
5. Add an App Icon in Assets.xcassets if desired.

## Build a test app
Select your physical iPhone/iPad as the run destination and press Run.

## Create an IPA
Product -> Archive -> Distribute App. For registered devices, use Ad Hoc; for TestFlight/App Store use the App Store Connect flow.

The resulting iOS package archive is an `.ipa`.
