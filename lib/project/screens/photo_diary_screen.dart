import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/diary_entry.dart';

const String diaryKey = 'photo_diary';

class PhotoDiaryScreen extends StatefulWidget {
  const PhotoDiaryScreen({super.key});

  @override
  State<PhotoDiaryScreen> createState() => _PhotoDiaryScreenState();
}

class _PhotoDiaryScreenState extends State<PhotoDiaryScreen> {
  final ImagePicker picker = ImagePicker();
  final captionController = TextEditingController();

  String? photoPath; // таңдалған суреттің жолы
  Position? position; // GPS нәтижесі
  String timeText = '-';
  bool isLoadingGps = false;

  List<DiaryEntry> entries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Уақытты "2026-11-24 14:30:15" түрінде жазамыз
  String formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} '
        '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }

  // ---------- Task 2: Камера / Галерея ----------
  Future<void> pickPhoto(ImageSource source) async {
    try {
      XFile? file = await picker.pickImage(
        source: source,
        imageQuality: 80, // сапасы 80%
        maxWidth: 1080, // ені 1080 px-тен аспайды
      );

      // Пайдаланушы ештеңе таңдамай жапса
      if (file == null || !mounted) return;

      setState(() {
        photoPath = file.path;
        timeText = formatTime(DateTime.now());
      });

      // Сурет түскеннен кейін GPS-ті автоматты түрде аламыз
      fetchLocation();
    } catch (e) {
      if (!mounted) return;
      // Мысалы, камераға рұқсат берілмесе
      showMessage('Could not open camera/gallery. Check permissions.');
    }
  }

  // ---------- Task 1 + 3: GPS ----------
  Future<void> fetchLocation() async {
    // 1) GPS қосулы ма?
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('GPS is turned off. Please enable it.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => Geolocator.openLocationSettings(),
          ),
        ),
      );
      return;
    }

    // 2) Рұқсатты тексереміз, жоқ болса сұраймыз
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (!mounted) return;
    if (permission == LocationPermission.denied) {
      showMessage('Location permission denied');
      return;
    }

    // "Don't ask again" басылса - тек Settings арқылы қосуға болады
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Permission denied forever. Open app settings.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => Geolocator.openAppSettings(),
          ),
        ),
      );
      return;
    }

    // 3) Позицияны аламыз, бұл кезде спиннер көрсетеміз
    setState(() {
      isLoadingGps = true;
    });

    try {
      // desiredAccuracy: LocationAccuracy.high - жаңа нұсқада осылай жазылады
      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      setState(() {
        position = pos;
        timeText = formatTime(DateTime.now());
      });
    } catch (e) {
      if (mounted) showMessage('Could not get location');
    }

    if (!mounted) return;
    setState(() {
      isLoadingGps = false;
    });
  }

  // ---------- Task 4: Күнделік ----------
  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(diaryKey);
    if (json == null || !mounted) return;

    List<dynamic> list = jsonDecode(json);
    List<DiaryEntry> saved = [];
    for (var item in list) {
      saved.add(DiaryEntry.fromJson(item));
    }
    setState(() {
      entries = saved;
    });
  }

  Future<void> saveEntries() async {
    List<Map<String, dynamic>> list = [];
    for (var entry in entries) {
      list.add(entry.toJson());
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(diaryKey, jsonEncode(list));
  }

  void saveEntry() {
    if (photoPath == null) {
      showMessage('Take or pick a photo first');
      return;
    }
    if (position == null) {
      showMessage('Fetch GPS location first');
      return;
    }

    String caption = captionController.text.trim();
    if (caption.isEmpty) {
      caption = 'No caption';
    }

    DiaryEntry entry = DiaryEntry(
      photoPath: photoPath!,
      caption: caption,
      latitude: position!.latitude,
      longitude: position!.longitude,
      time: timeText,
    );

    setState(() {
      entries.insert(0, entry); // жаңасы ең үстінде
      photoPath = null;
      position = null;
      timeText = '-';
    });
    captionController.clear();
    saveEntries();
    showMessage('Entry saved to diary');
  }

  void deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
    saveEntries();
  }

  // Web-те Image.file жұмыс істемейді, сондықтан Image.network қолданамыз
  Widget buildImage(String path, double size) {
    if (kIsWeb) {
      return Image.network(path, width: size, height: size, fit: BoxFit.cover);
    }
    return Image.file(File(path), width: size, height: size, fit: BoxFit.cover);
  }

  Widget buildPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 240,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: photoPath == null
            ? Icon(Icons.camera_alt, size: 80, color: Colors.grey.shade600)
            : buildImage(photoPath!, double.infinity),
      ),
    );
  }

  Widget buildInfo() {
    String lat = '-';
    String lng = '-';
    String acc = '-';
    if (position != null) {
      lat = position!.latitude.toStringAsFixed(6);
      lng = position!.longitude.toStringAsFixed(6);
      acc = '± ${position!.accuracy.toStringAsFixed(1)} m';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 Latitude:  $lat'),
            Text('📍 Longitude: $lng'),
            Text('🎯 Accuracy:  $acc'),
            Text('⏰ Timestamp: $timeText'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📸 Narxoz Photo Journal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildPreview(),
          const SizedBox(height: 12),
          buildInfo(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickPhoto(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickPhoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pick Gallery'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          isLoadingGps
              ? const Center(child: CircularProgressIndicator())
              : OutlinedButton.icon(
                  onPressed: fetchLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Fetch Current GPS Location'),
                ),
          const Divider(height: 32),
          TextField(
            controller: captionController,
            decoration: const InputDecoration(
              labelText: 'Caption',
              prefixIcon: Icon(Icons.edit_note),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: saveEntry,
            icon: const Icon(Icons.save),
            label: const Text('SAVE ENTRY TO DIARY'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '📜 Diary Entries (${entries.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('No entries yet')),
            ),
          for (int i = 0; i < entries.length; i++)
            Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: buildImage(entries[i].photoPath, 56),
                ),
                title: Text(entries[i].caption),
                subtitle: Text(
                  '${entries[i].latitude.toStringAsFixed(4)}° N, '
                  '${entries[i].longitude.toStringAsFixed(4)}° E\n'
                  '${entries[i].time}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => deleteEntry(i),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
