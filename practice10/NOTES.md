
Level 1:

Expected order:
A, C, B, 6 students.

Actual order:
A, C, fetchStudents #1, B, 6 students.

With three requests:
Unhandled Exception: Instance of 'NoConnectionException'

With sleep():
The app freezes because sleep blocks the event loop.

With await Future.delayed():
The app stays responsive because only the async function waits.
## Level 2 — mounted experiment

**Error without mounted checks:**

`setState() called after dispose()`

**Explanation:**

The screen was closed before the API request finished. When the request completed, the code tried to call setState() on a disposed State.

**Solution:**

I restored both `if (!mounted) return;` checks. They prevent setState() from being called after the screen is disposed.
## Level 3 — FutureBuilder

### 1. Future stored in a field
The Future is stored in `_future` and initialized in `initState()`. This prevents new API requests from being created every time `build()` runs.

### 2. Compact Switch test
I switched Compact on and off 10 times. The student list changed its density, but no additional API requests were made. Only `fetchStudents #1` appeared in the console.

### 3. Future inside build() test
I temporarily replaced `future: _future` with `future: _api.fetchStudents()`.

After switching Compact several times, new API requests appeared in the console (`fetchStudents #2`, `#3`, `#4`). The loading indicator appeared again because every rebuild created a new Future.

I restored `future: _future` after the test.

## Level 4 — Countdown

### Version A — StreamBuilder
StreamBuilder automatically manages its stream subscription. When the screen is closed, it cancels the subscription. The console stops printing tick messages, even though I did not call cancel() manually.

### Version B — Manual subscription
I used listen() to subscribe to the countdown stream. I called _sub.cancel() inside dispose() before super.dispose(). When I closed the screen at 7, the console stopped printing tick messages.

### Version B — Without cancel()
I temporarily commented out _sub.cancel() and closed the screen at 7. The console continued printing tick 6, tick 5, and so on until tick 0. I also got the error:

setState() called after dispose()

This happened because the stream continued calling setState() after the screen was disposed.

### Conclusion
StreamBuilder manages the subscription automatically. When using listen(), I must cancel the subscription manually in dispose() to prevent memory leaks and setState() after dispose() errors.
## Level 5 — Save data

### 1. Successful save
When I pressed the Save button, the app called `save()` and waited for the operation to finish using `await`. If the save was successful, the screen closed with `Navigator.pop(context)`.

### 2. Error handling
Every second save request throws a `StateError`. I handled it using `try-catch`. When an error occurred, the app displayed the error message, and the screen stayed open.

Unhandled Exception: Bad state: server rejected 6

### 3. Saving state
While the save operation was running, the `_saving` variable was set to `true`. The Save button was disabled to prevent multiple requests. After the operation finished, `_saving` was set back to `false`.

### 4. Context safety
After `await`, I checked `context.mounted` before using `context` or calling `setState()`. This prevents using the context after the screen has been disposed.
