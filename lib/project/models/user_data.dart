import 'package:flutter/foundation.dart';

class UserData {
  final String name;
  final String email;
  final String city;
  bool notifications;

  UserData({
    required this.name,
    required this.email,
    required this.city,
    required this.notifications,
  });
}

final ValueNotifier<UserData?> currentUser = ValueNotifier(null);
