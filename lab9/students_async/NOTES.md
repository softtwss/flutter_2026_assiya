## Level 1 — Event Loop

Predicted order:
A
C
First app frame
B
6 students

Actual console output:
A
C
fetchStudents #1
B
6 students

Observation:
Future.delayed does not block the application.
The app continues running while the Future is waiting.

Future.delayed:
The application continues running while waiting.

sleep:
The application is blocked during the delay.

Conclusion:
Future.delayed is non-blocking, while sleep blocks the event loop.


## Level 2 — Four States by Hand

In this level, I created a StudentsScreen using StatefulWidget.

I used three fields:
- `_students` — stores the student list.
- `_error` — stores an error.
- `_api` — provides fake student data.

The screen has four states:

1. Loading — shows a spinner while students are loading.
2. Error — shows "Could not load students" and a Retry button.
3. Empty — shows "No students yet".
4. Data — displays six students in a ListView.

I used `initState()` to start loading and `setState()` to update the UI.

I used `try/catch` to handle API errors.

I used `if (!mounted) return;` after `await` to prevent updating a widget after it was removed.

### Testing

- Loading: The spinner appeared for two seconds.
- Data: Six students were displayed.
- Empty: `FakeApi(empty: true)` showed "No students yet".
- Error: The third API request showed an error and a Retry button.
- Retry: The next request loaded students successfully.

### Mounted Experiment

Without the mounted check, leaving the screen during loading can cause:

`setState() called after dispose()`

After restoring the mounted checks, the screen can be closed safely during loading.

---

## Level 3 — FutureBuilder Done Right

In this level, I created StudentsFutureScreen using FutureBuilder.

FutureBuilder automatically handles asynchronous data.

I used:

- `late Future<List<Student>> _future` to store the Future.
- `initState()` to initialize the Future once.
- `snapshot.hasError` to check for errors.
- `snapshot.connectionState` to check loading.
- `snapshot.data ?? const []` to handle empty data.
- `Switch` to change between normal and compact list views.

### Testing

- Loading: A spinner appeared while waiting for data.
- Data: Six students were displayed after two seconds.
- Error: The error view displayed a Retry button.
- Compact Switch: The list changed its appearance.

### Switch Experiment

I switched Compact on and off 10 times.

The console showed only one API request:

`fetchStudents #1`

This happened because the Future was stored in a field.

### Broken Version

I temporarily used:

`future: _api.fetchStudents()`

inside the build method.

Every rebuild created a new API request.

The console showed:

`fetchStudents #2`
`fetchStudents #3`
`fetchStudents #4`

This caused repeated loading and API errors.

I restored:

`future: _future`

### Conclusion

A Future should be stored outside the build method to avoid unnecessary API requests.

FutureBuilder makes asynchronous UI code simpler than managing all states manually.


## Level 4 — Countdown and Streams

I created a countdown from 10 to 0 using Stream<int>.

The countdown uses async*, yield, and Future.delayed.

### Version A — StreamBuilder

StreamBuilder listens to the stream and displays each number.

When the screen is closed, StreamBuilder cancels its subscription automatically.

### Version B — StreamSubscription

I used listen() to receive numbers and setState() to update the UI.

I used cancel() in dispose() to stop the subscription when leaving the screen.

### Cancellation Experiment

Without cancel(), the subscription continued receiving values after the screen was closed.

Without mounted protection, this caused:

setState() called after dispose()

After restoring cancel(), the subscription stopped when the screen was closed.

### Conclusion

StreamBuilder manages its subscription automatically.

A manual StreamSubscription must be cancelled in dispose() to avoid updates after the widget is removed.


## Level 5 — Errors That Do Not Vanish

I added a Save button to the By-hand screen.

The save() method waits one second and fails on every second call.

### Error Handling

I used await to wait for the save operation.

I used try / on StateError to catch server errors.

If saving succeeds, Navigator.pop(context) closes the screen.

If saving fails, a SnackBar displays the error message.

### Mounted Check

I used mounted after await to avoid using a disposed widget.

### Saving State

I added a boolean _saving.

While saving:
- The Save button is disabled.
- A small CircularProgressIndicator is displayed.
- Multiple taps cannot start multiple requests.

### Unhandled Future Experiment

Without await and error handling, a failed save can produce:

DartError: Bad state: server rejected 6

The screen may close even though saving failed.

### Conclusion

Async operations must be awaited and errors must be handled.

The screen should close only after a successful save.
