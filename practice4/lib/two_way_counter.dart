import 'package:flutter/material.dart';

class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() {
    return _TwoWayCounterState();
  }
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _count = 0;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: _count == 0
                  ? null
                  : () {
                      setState(() {
                        _count--;
                      });
                    },
              child: const Text('-'),
            ),
            Text('$_count'),
            FilledButton(
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              child: const Text('+'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _saving
              ? null
              : () async {
                  setState(() {
                    _saving = true;
                  });

                  await Future.delayed(const Duration(seconds: 2));

                  if (!mounted) {
                    return;
                  }

                  setState(() {
                    _saving = false;
                  });

                  ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Saved')));
                },
          child: _saving
              ? const  CircularProgressIndicator(strokeWidth: 1)
              : const Text('Save'),
        ),
      ],
    );
  }
}
