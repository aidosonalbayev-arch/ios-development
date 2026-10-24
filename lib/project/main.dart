import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'models/place.dart';
import 'screens/detail_screen.dart';
import 'screens/register_screen.dart';
import 'screens/root_screen.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const RootScreen()),
    GoRoute(
      path: '/place/:id',
      redirect: (context, state) {
        int? id = int.tryParse(state.pathParameters['id']!);
        if (id == null || id < 0 || id >= places.length) {
          return '/';
        }
        return null;
      },
      builder: (context, state) {
        int id = int.parse(state.pathParameters['id']!);
        return DetailScreen(place: places[id - 1]);
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      routerConfig: _router,
    );
  }
}
