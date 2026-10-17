
import 'package:flutter/material.dart';

import 'models/workshop.dart';
import 'routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'screens/shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dance Workshops',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      initialRoute: Routes.shell,
      routes: {
        Routes.shell: (context) {
          return const Shell();
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.detail &&
            settings.arguments is DetailArguments) {
          final args = settings.arguments as DetailArguments;

          return MaterialPageRoute<void>(
            builder: (context) {
              return DetailScreen(arguments: args);
            },
          );
        }

        if (settings.name == Routes.form &&
            settings.arguments is FormArguments) {
          final args = settings.arguments as FormArguments;

          return MaterialPageRoute<Workshop>(
            builder: (context) {
              return WorkshopFormScreen(arguments: args);
            },
          );
        }

        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text('Not found'),
              ),
            );
          },
        );
      },
    );
  }
}
