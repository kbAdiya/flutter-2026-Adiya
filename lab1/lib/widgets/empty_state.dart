
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    required this.icon,
    this.buttonText,
    this.onPressed,
  });

  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onPressed != null)
            TextButton(
              onPressed: onPressed,
              child: Text(buttonText ?? ''),
            ),
        ],
      ),
    );
  }
}
