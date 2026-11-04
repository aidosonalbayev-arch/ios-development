import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/place.dart';
import 'providers/cart_provider.dart';
import 'screens/cart_screen.dart';
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
        if (id == null || findPlaceById(id) == null) {
          return '/';
        }
        return null;
      },
      builder: (context, state) {
        int id = int.parse(state.pathParameters['id']!);
        return DetailScreen(place: findPlaceById(id)!);
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
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
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Travel App',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
        routerConfig: _router,
      ),
    );
  }
}
