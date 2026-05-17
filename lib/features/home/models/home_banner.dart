class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String link;

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return HomeBanner(
      id: (json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: (image['url'] ?? '').toString(),
      link: (json['link'] ?? '').toString(),
    );
  }
}
