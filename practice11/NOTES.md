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