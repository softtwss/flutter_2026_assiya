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