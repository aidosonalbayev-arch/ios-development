import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) =>
          DetailsScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(path: '/form', builder: (context, state) => const FormScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      routerConfig: _router,
    );
  }
}

// ---------- Главный экран ----------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Навигация и формы')),
      body: ListView(
        children: [
          const ListTile(title: Text('Navigator')),
          ListTile(
            leading: const Icon(Icons.arrow_forward),
            title: const Text('Navigator.push + pop с результатом'),
            onTap: () async {
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (context) => const SecondScreen()),
              );
              if (!context.mounted || result == null) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result)));
            },
          ),
          const Divider(),
          const ListTile(title: Text('GoRouter')),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text("context.go('/details/42')"),
            subtitle: const Text('заменяет стек'),
            onTap: () => context.go('/details/42'),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("context.push('/details/7')"),
            subtitle: const Text('добавляет экран сверху'),
            onTap: () => context.push('/details/7'),
          ),
          const Divider(),
          const ListTile(title: Text('Ввод и формы')),
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('Форма: валидация и компоненты'),
            onTap: () => context.push('/form'),
          ),
        ],
      ),
    );
  }
}

// ---------- Экран для Navigator.push ----------
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Второй экран')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, 'Привет из второго экрана!'),
          child: const Text('Назад (pop с результатом)'),
        ),
      ),
    );
  }
}

// ---------- Экран с параметром из пути ----------
class DetailsScreen extends StatelessWidget {
  final String id;
  const DetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details $id')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('id из пути: $id', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            ElevatedButton(
              // после go() стека нет, поэтому проверяем canPop
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go('/'),
              child: const Text('Назад'),
            ),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('На главную (go)'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Форма: ввод, валидация, интерактивные компоненты ----------
class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _agree = false;
  bool _notifications = true;
  double _volume = 50;
  String _city = 'Алматы';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Нужно принять условия')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Сохранено: ${_nameController.text}, ${_emailController.text}, '
          '$_city, громкость ${_volume.round()}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Форма')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Введите имя';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Введите email';
                if (!value.contains('@')) return 'Неверный email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _city,
              decoration: const InputDecoration(
                labelText: 'Город',
                border: OutlineInputBorder(),
              ),
              items: [
                'Алматы',
                'Астана',
                'Шымкент',
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _city = v!),
            ),
            SwitchListTile(
              title: const Text('Уведомления'),
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
            Text('Громкость: ${_volume.round()}'),
            Slider(
              value: _volume,
              min: 0,
              max: 100,
              onChanged: (v) => setState(() => _volume = v),
            ),
            CheckboxListTile(
              title: const Text('Принимаю условия'),
              value: _agree,
              onChanged: (v) => setState(() => _agree = v!),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _submit, child: const Text('Отправить')),
          ],
        ),
      ),
    );
  }
}
