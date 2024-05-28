class FAQ {
  final int id;
  final String title;
  final String? content;

  FAQ({required this.id, required this.title, this.content});

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}
