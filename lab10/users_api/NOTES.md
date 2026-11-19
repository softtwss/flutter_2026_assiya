
# Practice 11 — A Real Server

## Level 1 — Postman First

API: https://jsonplaceholder.typicode.com

### User JSON Fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| id | number | int | No |
| name | string | String | No |
| username | string | String | No |
| email | string | String | No |
| address | object | Address | No |
| phone | string | String | No |
| website | string | String? | Yes |
| company | object | Record | No |

### Address Fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| street | string | String | No |
| suite | string | String | No |
| city | string | String | No |
| zipcode | string | String | No |
| geo | object | Geo | No |

### Geo Fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| lat | string | double | No |
| lng | string | double | No |

### Company Fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| name | string | String | No |
| catchPhrase | string | String | No |
| bs | string | Not stored | No |

### API Tests

GET /users:
- Expected: 10 users
- Actual status: TODO
- Content-Type: TODO

GET /users/1:
- Expected: one user object
- Actual status: TODO

GET /users/999:
- Actual status: TODO
- Response body: TODO

GET /users?id=3:
- Expected: list containing one user
- Actual result: TODO

POST /users:
- Actual status: TODO
- Server-generated ID: TODO

## Level 2 — User Model

Created Geo, Address, and User models.

Used fromJson() to convert JSON into Dart objects.
Used toJson() to convert objects back into JSON.

Used double.parse() because the API sends coordinates
as strings.

Website is nullable.

PhoneDigits removes unnecessary characters.

Round-trip and invalid JSON experiments: TODO.

## Level 3 — Repository

Created ApiClient and UserRepository.

ApiClient handles HTTP requests, status codes,
JSON decoding, and a 10-second timeout.

Repository returns User models instead of HTTP responses.

404 status test and malformed response experiment: TODO.

## Level 4 — ChangeNotifier

Created UsersModel using ChangeNotifier.

The model manages:
- loading
- error
- items
- saving

Used Provider to connect the model to the screen.

Used a sealed ApiException switch for error handling.

Added Retry, RefreshIndicator, and UserDetailScreen.

Host typo and exhaustive switch experiments: TODO.

## Level 5 — Network and POST

Implemented a New User form with validation.

Save waits for the server response.
The button is disabled while saving.

Airplane mode timing: TODO
Dead Wi-Fi timing: TODO

DevTools screenshots:
- screenshot_timeout.png
- screenshot_200.png

POST status and double-tap verification: TODO

## Conclusion

In this practice, I learned how to work with a real API
in Flutter using HTTP, JSON models, repositories,
ChangeNotifier, Provider, and error handling.
