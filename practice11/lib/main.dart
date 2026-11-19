import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_client.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_model.dart';
import 'features/users/users_screen.dart';
import 'features/settings/settings_model.dart';

import 'core/storage/secure_store.dart';
import 'features/auth/auth_model.dart';
import 'features/auth/login_screen.dart';
import 'features/users/users_cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = SharedPreferencesAsync();

  final bool dark = await prefs.getBool('darkMode') ?? false;

  final String? city = await prefs.getString('cityFilter');

  final secureStore = SecureStore();
  final String? token = await secureStore.readToken();

  final client = http.Client();
  final api = ApiClient(client, secureStore);
  final cache = UsersCache();
  final repository = UserRepository(api, cache);

  runApp(
    MultiProvider(
      providers: [
        Provider<SecureStore>(
          create: (context) {
            return secureStore;
          },
        ),

        ChangeNotifierProvider(
          create: (context) {
            return SettingsModel(prefs, dark, city);
          },
        ),

        ChangeNotifierProvider(
          create: (context) {
            return AuthModel(secureStore, token);
          },
        ),

        ChangeNotifierProvider(
          create: (context) {
            final model = UsersModel(repository);

            if (token != null) {
              model.load();
            }

            return model;
          },
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final auth = context.watch<AuthModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: settings.dark ? ThemeMode.dark : ThemeMode.light,

      home: auth.signedIn ? const UsersScreen() : const LoginScreen(),
    );
  }
}
