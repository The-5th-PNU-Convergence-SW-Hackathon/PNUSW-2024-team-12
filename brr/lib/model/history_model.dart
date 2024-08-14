class History {
  int id;
  String title;
  String content;
  DateTime timestamp;
  int likes;

  History({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.likes,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}