import 'dart:async';

import 'package:flutter/material.dart';

import 'api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  String _version = 'A';

  // ver a
  late final Stream<int> _stream = countdown(10);

  // ver b
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();

    _sub = countdown(10).listen((i) {
      setState(() {
        _left = i;
      });
    });
  }

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'A',
                label: Text('Version A'),
              ),
              ButtonSegment(
                value: 'B',
                label: Text('Version B'),
              ),
            ],
            selected: {_version},
            onSelectionChanged: (selection) {
              setState(() {
                _version = selection.first;
              });
            },
          ),

          Expanded(
            child: IndexedStack(
              index: _version == 'A' ? 0 : 1,
              children: [
                // Version A
                Center(
                  child: StreamBuilder<int>(
                    stream: _stream,
                    builder: (context, snapshot) {
                      return Text(
                        '${snapshot.data ?? 10}',
                        style: Theme.of(context).textTheme.displayLarge,
                      );
                    },
                  ),
                ),


                Center(
                  child: Text(
                    '$_left',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}