# Practice 12 — Survive a Restart

## Level 1 — Package Evaluation

- **shared_preferences** — Flutter package published by flutter.dev, supporting Android, iOS, Linux, macOS, Windows and Web, using platform-specific implementations for persistent settings under the BSD-3-Clause licence.
- **flutter_secure_storage** — A cross-platform package for secure storage that uses platform-specific security mechanisms and is distributed under the BSD-3-Clause licence.
- **path_provider** — Flutter package published by flutter.dev, supporting Android, iOS, Linux, macOS and Windows, providing access to application directories through platform-specific implementations under the BSD-3-Clause licence.
- **image_picker** — Flutter package published by flutter.dev, supporting mobile, desktop and web platforms, using platform-specific implementations for selecting images under the BSD-3-Clause licence.
- **permission_handler** — A package published by Baseflow that provides runtime permission management through platform-specific implementations under the MIT licence.
- **url_launcher** — Flutter package published by flutter.dev, supporting Android, iOS, Linux, macOS, Windows and Web, using platform-specific implementations to open external applications under the BSD-3-Clause licence.

Exact release dates, pub points and repository activity require additional verification on pub.dev.

### Dependency versions

The resolved version of `http` in pubspec.lock was 1.6.0.

The constraint `^1.2.0` accepts versions from 1.2.0 up to, but not including, 2.0.0. It accepts versions such as 1.2.1 and 1.6.0, but refuses 1.1.0 and 2.0.0.

The pubspec.lock file should be committed because it records exact dependency versions and provides reproducible builds.

### Dependency experiment

I temporarily changed the http constraint from `^1.2.0` to `1.2.0`.

The dependency resolution failed because http 1.2.0 and permission_handler_html required incompatible versions of the web package. I restored a compatible caret constraint.

I also ran `flutter pub outdated`. A newer major version of cupertino_icons was available, but I kept the compatible version because a major upgrade was unnecessary for this practice.

During Android testing, permission_handler 13.0.2 caused an Android SDK compatibility problem. I used version 12.0.1 to resolve the build issue.

## Level 2 — Persistent Settings

I implemented dark mode and a city filter using SharedPreferencesAsync.

SettingsModel updates its values and calls notifyListeners() before writing the changes to storage.

The saved settings are read in main() before runApp(), so the application starts with the correct theme and city filter.

### Test results

- Dark mode survives an application restart.
- The selected city filter survives an application restart.
- The correct theme is applied at startup.

### Intentional experiment

I temporarily moved the asynchronous theme loading into SettingsModel and used false as the initial dark mode value.

The application initially displayed the light theme before switching to the saved dark theme.

This demonstrated why persistent settings should be loaded before runApp(). I restored the original implementation.

## Level 3 — Secure Storage

I implemented SecureStore using flutter_secure_storage.

The application provides a fake login that accepts a password with at least eight characters and generates a test token.

The token is stored securely and restored during application startup.

ApiClient reads the token and adds the Authorization header using the Bearer authentication scheme.

Signing out deletes the stored token. The application also provides a debug-only button to copy the token without printing it in the console.

### Storage and security

SharedPreferences is suitable for non-sensitive settings but should not be used for authentication tokens.

Traditional SharedPreferences implementations store values in an XML file on Android or a preferences plist on iOS. Depending on device configuration, backups, root access or debugging tools connected through a cable may expose these values.

Secure storage uses platform-specific security mechanisms, including Android Keystore-backed protection and iOS Keychain.

On iOS, Keychain entries may survive application uninstallation.

On Android, removing the device lock screen may invalidate authentication-bound encryption keys, depending on their configuration.

The authentication implemented in this practice is simulated and is not a production authentication system.

## Level 4 — Offline Cache

I implemented UsersCache using path_provider and the application Documents directory.

The user list is serialized into JSON and saved in users.json.

UserRepository first attempts to fetch fresh data from the API. If the network is unavailable, it loads the previously saved list.

The fromCache property indicates whether the displayed data comes from local storage.

When cached data is displayed, the application shows the banner:

Saved data · no connection · Retry

### Test results

- The application loads and saves ten users while online.
- Previously saved users remain available without an internet connection.
- The offline banner appears when cached data is displayed.
- Retry allows the application to request fresh data.
- After uninstalling and reinstalling the application, opening it offline displays an offline error instead of an empty list.

### Temporary directory experiment

I temporarily replaced getApplicationDocumentsDirectory() with getTemporaryDirectory().

After loading the users, I cleared the application cache and reopened the application without an internet connection.

The saved user list was no longer available.

This demonstrated that temporary files can be removed by the operating system and should not be used for important persistent data.

I restored getApplicationDocumentsDirectory() after the experiment.

## Level 5 — Profile Photo and Permissions

I implemented a Profile screen using image_picker and permission_handler.

The user can select a photo from the gallery or take a photo using the camera.

The selected image is copied into the Documents directory as avatar.jpg, and its path is stored in SharedPreferences.

Camera permission is requested only when the user presses Take photo.

### Permission handling

- Granted: the camera opens.
- Denied: a SnackBar explains that permission is required.
- Permanently denied: a custom AlertDialog provides an Open settings button.
- Restricted or limited: the application handles the status without crashing.

If the user cancels image selection, the application handles the null result safely.

Android camera permissions are declared in AndroidManifest.xml. Camera and photo library usage descriptions are declared in the iOS Info.plist.

### Android permission test

I tested the camera permission denial flow on the Android emulator.

After repeated permission denials, the application displayed its own permission dialog with an Open settings button.

The required permission dialog screenshot was captured.

### iOS permission behaviour

On iOS, one denial of camera permission is generally enough for subsequent requests to require the user to open system settings.

The additional Photos permission state is called limited. It allows users to grant access only to selected photos.

The iOS behaviour is documented theoretically; practical testing was performed on Android.

### URL Launcher

The User Details screen supports three external link schemes:

- mailto: opens an email application.
- tel: opens a phone application.
- https: opens a website in the browser.

The application checks the result returned by launchUrl() and displays a message if no application can open the link.

A URL without a scheme, such as kbtu.edu.kz, may fail to open. Adding https:// creates a valid web URL.

## Screenshots

- screenshot_offline_banner.png — cached user list displayed without an internet connection.
- screenshot_permission_dialog.png — custom dialog displayed when camera permission is permanently denied.

## Conclusion

In this practice, I learned how to store application settings, protect authentication tokens, cache API responses, manage runtime permissions and open external applications.

The main difference between the three storage mechanisms is their purpose:

- SharedPreferences: non-sensitive application settings.
- Secure Storage: sensitive authentication information.
- Documents directory: persistent files and cached application data.

Temporary storage should only be used for files that can safely be deleted.

The application can restore saved settings, handle offline situations and respond safely when a user denies permission.