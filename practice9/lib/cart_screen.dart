import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  bool isTotalExpanded = true;

  Future<void> clearCart() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cart'),
          content: const Text('Are you sure you want to clear the cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (confirmed == true) {
      context.read<Cart>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            tooltip: 'Clear cart',
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              clearCart();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }

                return ListView(
                  children: cart.items.map((book) {
                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text('${book.price} ₸'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('×${cart.qtyOf(book)}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cart.increment(book);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              cart.remove(book);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          ListTile(
            title: const Text('Total'),
            trailing: Icon(
              isTotalExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                isTotalExpanded = !isTotalExpanded;
              });
            },
          ),

          if (isTotalExpanded)
            Consumer<Cart>(
              child: const TotalLabel(),
              builder: (context, cart, child) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      child!,
                      Text(
                        '${cart.total} ₸',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class TotalLabel extends StatelessWidget {
  const TotalLabel({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('TotalLabel build');

    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.payments),
        SizedBox(width: 8),
        Text(
          'Total: ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
