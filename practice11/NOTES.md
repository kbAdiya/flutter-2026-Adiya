# Practice 11 — A Real Server

## Level 1: Postman First

### 1. GET /users

**URL:** https://jsonplaceholder.typicode.com/users

**Status:** 200 OK

**Content-Type:** application/json

The server returns an array of 10 users.

### 2. User fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| id | number | int | No |
| name | string | String | No |
| username | string | String | No |
| email | string | String | No |
| address | object | Address | No |
| phone | string | String | No |
| website | string | String? | Yes |
| company | object | ({String name, String catchPhrase}) | No |

### 3. Address fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| street | string | String | No |
| suite | string | String | No |
| city | string | String | No |
| zipcode | string | String | No |
| geo | object | Geo | No |

### 4. Geo fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| lat | string | double | No |
| lng | string | double | No |

Latitude and longitude are strings in JSON. We use `double.parse()` to convert them into doubles in Dart.

### 5. Company fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| name | string | String | No |
| catchPhrase | string | String | No |
| bs | string | String | No |

### 6. GET /users/999

**Status:** 404 Not Found

**Body:** `{}`

The requested user does not exist.

### 7. POST /users

**Status:** 201 Created

**Request body:**

```json
{
  "name": "Adiya",
  "username": "adiya123",
  "email": "adiya@example.com"
}
```

**Response body:**

```json
{
  "name": "Adiya",
  "username": "adiya123",
  "email": "adiya@example.com",
  "id": 11
}
```

The server adds a new ID to the submitted data.

### 8. GET /users?id=3

**status:** 200 OK

The query parameter `id=3` filters the user list. The response is an array containing one user, not a single object.

Level 5: Network Testing and POST from UI

Test 1: No Network Connection

Connection: Internet disabled
Expected result: No internet connection screen with Retry button

Observed result: The application displayed the no-connection error screen.

Test 2: Wi-Fi Without Internet

Device: Samsung 
Connection: Wi-Fi connected without internet
Timeout configured: 10 seconds

Expected result: The request should stop waiting after approximately 10 seconds if no response arrives, and the application should display the Offline screen.


Test 3: Successful GET Request

Method: GET
Endpoint: /users
Status: 200 OK

The Network panel displayed a successful request. The response contained the list of users.


POST from Flutter UI

A New User form was implemented with the following input fields:

Name

Username

Email

The form includes required-field validation and email-format validation.

The Save button calls the createUser method in UsersModel, which uses UserRepository.create() to send a POST request.

After a successful request, the newly created user is inserted at the beginning of the list and the form closes.

POST Request Validation

Expected status: 201 Created
Expected server-generated ID: 11

The Save button is disabled while the request is in progress. An additional saving-state check prevents repeated requests during submission.

Double-tap Network verification: Not yet recorded.

If an API error occurs, the form remains open and a SnackBar displays an error message.


## Practice 12 — Level 1: Package Evaluation

### 1. Checking outdated packages

I ran the command:

`flutter pub outdated`

The command showed that some packages have newer versions available.

For example:

- `cupertino_icons`: Current version is 1.0.9, latest version is 2.0.0.
- `shared_preferences_foundation`: Current version is 2.5.7, latest version is 2.6.2.
- `meta`: Current version is 1.18.3, latest version is 1.19.0.

I did not upgrade `cupertino_icons` because version 2.0.0 is a major update, and my current project uses an older version constraint. Updating to a new major version may introduce breaking changes.

Seven dependencies are locked to older versions in `pubspec.lock`.

### 2. Version Constraints (^ caret)

The caret (`^`) allows compatible package updates.

For example, `^1.2.0` accepts:

- 1.2.0 — accepted
- 1.2.5 — accepted
- 1.9.0 — accepted
- 2.0.0 — rejected
- 1.1.9 — rejected

This is because `^1.2.0` means versions greater than or equal to 1.2.0 but lower than 2.0.0.

### 3. Why pubspec.lock is important

`pubspec.lock` stores the exact versions of the dependencies used in the project.

We commit this file to Git because it helps everyone working on the application use consistent package versions and avoid unexpected changes.

### 4. HTTP Package

The exact resolved version of http is: 1.6.0.

### Exact Version Experiment

My original HTTP dependency was `http: ^1.6.0`.

I temporarily changed it to `http: 1.2.0` and ran `flutter pub get`.

**Result:** Dependency resolution failed because of a version conflict.

The package `http 1.2.0` requires `web >=0.3.0 <0.5.0`, while `permission_handler 13.0.2` depends on `permission_handler_html`, which requires `web >=0.5.1 <2.0.0`.

These version requirements are incompatible, so Flutter could not resolve the dependencies.

I also ran `flutter pub outdated`, but it showed "No resolution was found" because of the conflict.

**Conclusion:** Exact versions can cause dependency conflicts. The caret (`^`) allows compatible updates and gives Flutter more flexibility when resolving dependencies.

I restored `http: ^1.6.0` to keep the project compatible with the other packages.

## Level 3: Secure Token Storage

I implemented a fake login system using `flutter_secure_storage`.

The application generates a token when the user enters a password containing at least 8 characters. The token is stored securely using Android Keystore or iOS Keychain.

The `ApiClient` automatically reads the token and adds it to the Authorization header as `Bearer token`.

The token survives an application restart and is deleted when the user signs out.

**Why not shared_preferences?**

`shared_preferences` stores values in ordinary application storage, such as XML files on Android or plist files on iOS. These values are not designed to protect secrets and may be exposed through backups or a compromised device.

**Platform differences:**

- On iOS, Keychain data may survive app uninstallation.
- On Android, secure storage data may become inaccessible if the device's security settings change, such as removal of the lock screen.

Therefore, authentication tokens should be stored in secure storage rather than shared preferences.

## Level 4 — Offline Users Cache

I implemented offline caching using `path_provider` and `dart:io`.

The application saves the last successfully fetched users list in a file called `users.json` inside the application's Documents directory.

When the network is available, `UserRepository` fetches fresh users from the API and updates the cache.

When a `NoConnectionException` occurs, the repository tries to load the saved users from the file.

If cached users are available, the app displays them with the message "Saved data · no connection" and a Retry button.

If no cached file exists, the application shows the original "No internet connection" error with Retry.

**Why Documents instead of Temporary?**

`getApplicationDocumentsDirectory()` provides persistent storage that normally survives application restarts.

`getTemporaryDirectory()` is not suitable because the operating system may delete temporary files when clearing cache or freeing storage.

The cache is removed when the application's data is deleted or the app is uninstalled.

## Level 5 — Camera, Permissions and URL Launcher

I implemented a profile screen using `image_picker`.

The user can select a photo from the gallery or take a new photo using the camera.

The selected image is copied to the application's Documents directory as `avatar.jpg`. Its path is saved in `shared_preferences`, so the photo survives an application restart.

### Camera Permissions

The application requests camera permission only when the user taps Take photo.

- Granted: The camera opens.
- Denied: A SnackBar explains why camera access is needed.
- Permanently denied: An AlertDialog asks the user to open the application settings.
- Cancel: No photo is selected, and the application continues working.

On Android 11+, repeated denials can cause the system to stop showing the permission dialog.

On iOS, one denial can require the user to enable access manually through Settings.

The additional photo permission state on iOS is called `limited`. It means the user allows access to only selected photos.

### URL Launcher

I implemented three URL schemes:

- `mailto:` opens an email application.
- `tel:` opens the phone dialer.
- `https:` opens a website in the browser.

The application checks the boolean returned by `launchUrl`. If no application can handle the URL, it displays an error message.

### Documents vs Temporary Storage

I used `getApplicationDocumentsDirectory()` because profile photos should survive application restarts.

Temporary storage is not suitable because the operating system may delete temporary files.