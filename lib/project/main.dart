import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/auth_cubit.dart';
import 'bloc/cart_bloc.dart';
import 'models/app_settings.dart';
import 'models/place.dart';
import 'screens/cart_screen.dart';
import 'screens/login_screen.dart';
import 'screens/photo_diary_screen.dart';
import 'screens/place_detail_screen.dart';
import 'screens/register_screen.dart';
import 'screens/root_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  final prefs = await SharedPreferences.getInstance();
  isDarkMode.value = prefs.getBool(darkModeKey) ?? false;

  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/login', // қолданба Login экранынан басталады
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/', builder: (context, state) => const RootScreen()),
    // Login-нан кейін бірден Shop (Catalog) табы ашылады
    GoRoute(
      path: '/shop',
      builder: (context, state) => const RootScreen(startIndex: 2),
    ),
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
    // LW13: суретті күнделік
    GoRoute(
      path: '/diary',
      builder: (context, state) => const PhotoDiaryScreen(),
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
    // AuthCubit пен CartBloc бүкіл қолданбаға ортақ
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: ValueListenableBuilder<bool>(
        valueListenable: isDarkMode,
        builder: (context, dark, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Travel App',
            theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.teal,
              brightness: Brightness.dark,
            ),
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
