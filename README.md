# QR Scanner (Flutter)

Four screens only: Splash -> Home -> Scanner -> Result (Scan Again -> Scanner).
Offline, no backend, no QR generation.

## Structure
```
lib/
  main.dart
  constants/      app_colors.dart, app_strings.dart
  theme/          app_theme.dart
  utils/          size_utils.dart (MediaQuery sizing), url_helper.dart
  common_widgets/ common_text, common_button, common_icon_button,
                  common_snackbar, common_dialog, common_status_view,
                  scan_frame_overlay
  controllers/    splash, scanner, result (GetX)
  views/          splash_view, home_view, scanner_view, result_view
  routes/         app_routes.dart
```

## Setup
1. Create the platform folders in this directory (keeps your existing config):
   `flutter create --org com.example --project-name qr_scanner .`
2. `flutter pub get`
3. Apply the platform config below.
4. `flutter run`

## Android
`android/app/build.gradle(.kts)`: set `minSdk = 21` (ML Kit needs 21+).

`android/app/src/main/AndroidManifest.xml`, inside `<manifest>` (before `<application>`):
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
```
Also inside `<manifest>`, so Open Link works on Android 11+:
```xml
<queries>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="http"/></intent>
</queries>
```
Set `android:label="QR Scanner"` on `<application>`.

## iOS
`ios/Runner/Info.plist`, inside the root `<dict>`:
```xml
<key>NSCameraUsageDescription</key>
<string>QR Scanner uses the camera only to read QR codes. Nothing is stored or uploaded.</string>
<key>LSApplicationQueriesSchemes</key>
<array><string>https</string><string>http</string></array>
```
`ios/Podfile`: set `platform :ios, '15.5'` at the top, and inside `post_install`
add the permission_handler macro:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
      ]
    end
  end
end
```
Then `cd ios && pod install`. Camera does not work on the iOS simulator; test on a device.

## Release builds
- `flutter build apk --release`
- `flutter build appbundle --release`
- `flutter build ios --release` (then sign in Xcode)

## Behaviour notes
- Camera permission is requested only when the Scanner opens (never on Splash).
- Denied: "Allow Camera" button. Permanently denied: dialog + "Open Settings".
  Returning from Settings re-checks the permission automatically.
- One scan per result: detection is locked until you come back from Results.
- Torch button appears only if the device reports a torch.
- Camera stops when the app is backgrounded or the screen is left, and is disposed.
- "Open Link" appears only for valid http/https URLs and never opens automatically.
- Decoded values are never logged or stored.
