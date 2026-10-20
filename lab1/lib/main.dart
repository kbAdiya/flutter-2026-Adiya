import 'package:flutter/material.dart';

import 'models/workshop.dart';
import 'routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'screens/shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dance Workshops',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      initialRoute: Routes.shell,
      routes: {
        Routes.shell: (context) {
          return Shell(
            themeMode: _themeMode,
            onThemeChanged: (mode) {
              setState(() {
                _themeMode = mode;
              });
            },
          );
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
            return const Scaffold(body: Center(child: Text('Not found')));
          },
        );
      },
    );
  }
}
