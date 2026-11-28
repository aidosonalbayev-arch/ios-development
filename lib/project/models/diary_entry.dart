// Күнделіктің бір жазбасы: сурет, жазу, координата, уақыт
class DiaryEntry {
  final String photoPath;
  final String caption;
  final double latitude;
  final double longitude;
  final String time;

  DiaryEntry({
    required this.photoPath,
    required this.caption,
    required this.latitude,
    required this.longitude,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'photoPath': photoPath,
      'caption': caption,
      'latitude': latitude,
      'longitude': longitude,
      'time': time,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      photoPath: json['photoPath'] ?? '',
      caption: json['caption'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      time: json['time'] ?? '',
    );
  }
}
