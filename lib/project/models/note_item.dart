class NoteItem {
  final int id;
  final String title;
  final String dateText;
  bool isCompleted;

  NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateText': dateText,
      'isCompleted': isCompleted,
    };
  }

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      dateText: json['dateText'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
