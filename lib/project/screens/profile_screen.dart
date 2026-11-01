import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool emailOffers = false;

  void openRegister() {
    context.push('/register');
  }

  void logOut() {
    currentUser.value = null;
  }

  Widget buildGuest() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 32),
        const Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person_outline, size: 60, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Welcome, Guest',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'You are not registered yet.\nCreate an account to save your profile.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: openRegister,
          icon: const Icon(Icons.person_add),
          label: const Text('Create account'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget buildUser(UserData user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal,
            child: Text(
              user.name.trim().isEmpty
                  ? '?'
                  : user.name.trim()[0].toUpperCase(),
              style: const TextStyle(fontSize: 42, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            user.email,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.location_city),
                title: const Text('City'),
                trailing: Text(user.city),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Notifications'),
                secondary: const Icon(Icons.notifications),
                value: user.notifications,
                onChanged: (value) {
                  setState(() {
                    user.notifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Email offers'),
                secondary: const Icon(Icons.email),
                value: emailOffers,
                onChanged: (value) {
                  setState(() {
                    emailOffers = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: logOut,
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserData?>(
      valueListenable: currentUser,
      builder: (context, user, child) {
        if (user == null) {
          return buildGuest();
        }
        return buildUser(user);
      },
    );
  }
}
