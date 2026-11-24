import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_client.dart';
import 'core/storage/secure_store.dart';
import 'features/auth/auth_model.dart';
import 'features/auth/login_screen.dart';
import 'features/settings/settings_model.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_model.dart';
import 'features/users/users_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = SharedPreferencesAsync();

  final dark = await prefs.getBool('darkMode') ?? false;
  final city = await prefs.getString('cityFilter');

  final store = SecureStore();
  final token = await store.readToken();

  final api = ApiClient(http.Client(), store);

  runApp(
    MultiProvider(
      providers: [
        Provider<SecureStore>.value(value: store),
        Provider<ApiClient>(
          create: (_) => api,
          dispose: (_, value) => value.close(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsModel(prefs, dark: dark, city: city),
        ),
        ChangeNotifierProvider(create: (_) => AuthModel(store, token)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final auth = context.watch<AuthModel>();

    return MaterialApp(
      key: ValueKey(auth.signedIn),
      debugShowCheckedModeBanner: false,
      title: 'Users API',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: settings.dark ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        if (!auth.signedIn) {
          return child ?? const SizedBox.shrink();
        }

        return ChangeNotifierProvider(
          create: (context) {
            final model = UsersModel(UserRepository(context.read<ApiClient>()));

            unawaited(model.load());

            return model;
          },
          child: child,
        );
      },
      home: auth.signedIn ? const UsersScreen() : const LoginScreen(),
    );
  }
}
