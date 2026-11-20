import 'package:flutter/foundation.dart';

const String darkModeKey = 'app_theme_dark_mode';
const String userNameKey = 'user_display_name';
const String notesKey = 'saved_notes';

final ValueNotifier<bool> isDarkMode = ValueNotifier(false);
