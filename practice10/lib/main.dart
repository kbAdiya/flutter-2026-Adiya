import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'students_screen.dart';
import 'students_future_screen.dart';
import 'countdown_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  static final FakeApi api = FakeApi();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Async'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentsScreen(
                      api: MyApp.api,
                    ),
                  ),
                );
              },
              child: const Text('By hand'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentsFutureScreen(),
                  ),
                );
              },
              child: const Text('FutureBuilder'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CountdownScreen(),
                  ),
                );
              },
              child: const Text('Countdown'),
            ),
          ],
        ),
      ),
    );
  }
}