# Practice 9 — Notes

## Level 1: Lift it up

The cart state is stored in Shell, above MaterialApp.

BooksScreen receives the cart and onAdd callback.
CartScreen receives the items and onRemove callback.
CartBadge receives count and total.

To add the total to the badge, I changed 1 constructor
in cart_badge.dart and updated its usage in books_screen.dart.

## Rebuild counter

BooksScreen build: to be measured
Book rows: 6 per BooksScreen build


## Level 2 — ChangeNotifier

I moved Book and books into models/book.dart.
I created Cart using ChangeNotifier.

Cart stores a private list of books.
It prevents duplicates and calculates the total price.
It uses notifyListeners() when the cart changes.

### Model Test Results

- After adding: 2 items
- Duplicate added: false
- After removing: 1 items, 3100 ₸
- All tests passed!

The items getter returns an unmodifiable list.
The test confirmed that modifying it directly throws UnsupportedError.

The Cart model does not use BuildContext.


## Level 3 — Provider

I used ChangeNotifierProvider above MaterialApp.

context.watch listens to changes.
context.read accesses the model without listening.
Consumer rebuilds the cart UI when the model changes.

BooksScreen and CartScreen no longer receive
cart data through constructors.

## Level 4 — Quantity and Rebuild Scope

I replaced the private list with Map<Book, int>.

count returns the number of distinct books.
qtyOf returns the quantity of a book.
increment increases the quantity.
total calculates price multiplied by quantity.

I compared context.watch and context.select
by pressing the + button three times.

Badge builds with watch: TO MEASURE
Badge builds with select: TO MEASURE

context.select reduces unnecessary rebuilds
when the selected value does not change.

I also used Consumer with a constant child
for the total price label.


## Level 5 — UI and Model Separation

I added a SnackBar that shows "Added" when
a book is successfully added to the cart.

The Cart model returns true or false from add().
The UI decides whether to show the SnackBar.

I added a Clear Cart button with a confirmation dialog.
The cart is cleared only after user confirmation.

I also added a search field to filter books
and a button to expand or collapse the total price.

## Where does it live?

Cart: Provided state.
It is shared between BooksScreen and CartScreen.

Search text: Ephemeral state.
It is only needed inside BooksScreen.

Total expanded/collapsed: Ephemeral state.
It is only needed inside CartScreen.

Theme mode: Lifted or provided state.
It should be shared because multiple screens
need the same theme setting.
