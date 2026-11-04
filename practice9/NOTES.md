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

## Level 3: Provider

### Experiment 1: watch instead of read

I replaced context.read<Cart>() with context.watch<Cart>()
inside the Add button's onPressed.

Error:
"Tried to listen to a value exposed with provider,
from outside of the widget tree."

Provider explained that an event handler (onPressed)
cannot create a listening dependency.

I fixed it by changing watch back to read.

### Experiment 2: read instead of watch

I replaced context.watch<Cart>() with context.read<Cart>()
inside CartBadge.build().

There was no error, but the cart badge did not update
when the cart changed.

This happened because read does not subscribe
to changes in Cart.

I fixed it by changing read back to watch.

### Final Rebuild Experiment

With context.watch:
3 increment presses = 3 badge rebuilds.

With context.select:
3 increment presses = 0 badge rebuilds.

context.watch rebuilds the badge whenever Cart
calls notifyListeners().

context.select only listens to cart.count.

When I increased the quantity of a book,
the number of distinct books did not change.

Therefore, context.select avoided unnecessary rebuilds.

I also moved the subscription from BooksScreen
into Consumer<Cart> inside each book row.

## Level 5: Logic on the Right Side

### SnackBar

The Cart model returns a bool from the add() method.

BooksScreen checks the returned value.

If the book was successfully added, the widget shows
a SnackBar with the message "Added".

The Cart model does not contain any UI logic.

### Clear Cart

The confirmation dialog is implemented in CartScreen.

showDialog<bool> returns true, false, or null.

After awaiting the result, I check mounted.

If the user confirms, the widget calls:

context.read<Cart>().clear();

The model only clears the data.

### Where does it live?

1. Cart - provided.

The cart is shared between BooksScreen, CartScreen,
and CartBadge. Therefore, it belongs in Provider.

2. Search text - ephemeral.

Search text is only needed inside BooksScreen.
Therefore, it is stored locally using setState().

3. Total expanded/collapsed - ephemeral.

This value only controls the appearance of CartScreen.
It is local UI state and does not need Provider.

4. Theme mode - provided.

If the application had a dark-mode switch, the theme
mode would be needed throughout the application.

Therefore, I would store it in a shared provider
above MaterialApp.