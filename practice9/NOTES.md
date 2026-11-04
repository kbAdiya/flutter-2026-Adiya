# Practice 9 - Notes

## Level 1: Lift It Up

### Constructor Changes

I modified 1 constructor: CartBadge.

Files changed:
- lib/cart_badge.dart
- lib/books_screen.dart

I added the total parameter to CartBadge.
BooksScreen now passes both count and total.

### Rebuild Counter

After pressing Add once:

- BooksScreen build: 1
- Book rows: 6
- Total debug messages: 7

The whole BooksScreen builds again after setState().
All six book rows are created again, even though
only one book was added.