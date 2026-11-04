
# Practice 9 — Put It High, Subscribe Low

## Level 1 — Lift It Up

In Level 1, I used the lifted state approach.

The cart state was stored in Shell, above MaterialApp.

BooksScreen received the cart and onAdd callback.
CartScreen received the items and onRemove callback.
CartBadge received count and total.

To display the total price in the badge, I changed
1 constructor in cart_badge.dart and updated its
usage in books_screen.dart.

### Rebuild Counter

I added debugPrint to BooksScreen and each book row.

The BooksScreen contains 6 book rows.

The exact rebuild count was not recorded.

## Level 2 — ChangeNotifier

I moved the Book class and books list into
models/book.dart.

I created Cart using ChangeNotifier.

The Cart model stores private cart data.
It prevents duplicate books and calculates
the total price.

I used notifyListeners() to notify widgets
when the cart changes.

### Model Test Results

I tested the Cart model using flutter test.

Results:

- After adding: 2 items
- Duplicate added: false
- After removing: 1 items, 3100 ₸
- All tests passed!

The items getter returns an unmodifiable list.

The test confirmed that trying to modify
this list directly throws UnsupportedError.

The Cart model does not use BuildContext.

## Level 3 — Provider

I added the provider package to the project.

I used ChangeNotifierProvider above MaterialApp
to share the Cart model between screens.

BooksScreen and CartScreen no longer receive
cart data through constructors.

I used:

- context.watch to listen to model changes.
- context.read to call model methods.
- Consumer to rebuild the cart UI.

### Provider Experiments

Using context.watch inside an onPressed callback
is incorrect because watch is intended for
listening during widget builds.

Using context.read for the badge count does not
subscribe the badge to changes, so the displayed
count may become outdated.

The final implementation uses context.read
inside callbacks and context.select inside
the badge build method.

The exact error messages from these experiments
were not recorded.

## Level 4 — Quantity and Rebuild Scope

I replaced the private cart list with
Map<Book, int> to store book quantities.

The Cart model now supports:

- count: number of distinct books.
- qtyOf: quantity of a specific book.
- increment: increases book quantity.
- total: calculates price multiplied by quantity.
- remove: removes a book.
- clear: removes all books.

I added a + button to increase book quantity.

For example, if one book costs 3100 ₸,
two copies cost 6200 ₸.

### Watch vs Select

I compared context.watch and context.select.

context.watch listens to all cart notifications.

context.select listens only to the selected value.

When I increase the quantity of an existing book,
the total price changes, but the number of
distinct books stays the same.

Therefore, context.select avoids unnecessary
badge rebuilds.

The exact rebuild counts were not recorded.

### Consumer Optimization

I used Consumer with a constant child
for the total price label.

This helps avoid rebuilding unchanged UI elements.

## Level 5 — UI and Model Separation

I added a SnackBar that displays "Added"
when a book is successfully added to the cart.

The Cart model returns true or false
from the add() method.

The UI decides whether to display the SnackBar.

I added a Clear Cart button with a
confirmation dialog.

If the user selects Cancel, the cart stays unchanged.

If the user selects Clear, all books are removed.

I also added a search field to filter books
by title.

The Cart screen has an expand/collapse option
to show or hide the total price.

## Where Does It Live?

### Cart

Provided state.

The cart is shared between BooksScreen
and CartScreen using ChangeNotifierProvider.

### Search Text

Ephemeral state.

Search text is only needed inside BooksScreen,
so it is stored locally using setState.

### Total Expanded/Collapsed

Ephemeral state.

This value is only needed inside CartScreen,
so it is stored locally using setState.

### Theme Mode

Lifted or provided state.

If theme switching is implemented, the theme
state should be shared between multiple screens.

The current application uses a fixed theme.

## Conclusion

In this practice, I learned how to manage
shared state in Flutter.

I first used lifted state and then replaced
it with ChangeNotifier and Provider.

I learned the difference between context.watch,
context.read, and context.select.

I also implemented book quantities,
total price calculation, search, SnackBar,
and a confirmation dialog.

Provider made the code easier to manage
and reduced unnecessary widget rebuilds.
