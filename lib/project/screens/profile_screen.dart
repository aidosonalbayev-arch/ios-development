import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notifications = true;
  bool emailOffers = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),
        const Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Aidos Onalbaev',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            'aidosonalbaev03@gmail.com',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Notifications'),
                secondary: const Icon(Icons.notifications),
                value: notifications,
                onChanged: (value) {
                  setState(() {
                    notifications = value;
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
        ElevatedButton.icon(
          onPressed: () {
            context.push('/register');
          },
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
}
