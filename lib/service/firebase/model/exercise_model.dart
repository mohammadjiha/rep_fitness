class Exercise {
  final String id;
  final String name;
  final String imageUrl;
  final String level;
  final String targetMuscles;
  final int order;
  final bool isActive;

  Exercise({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.level,
    required this.targetMuscles,
    required this.order,
    required this.isActive,
  });

  factory Exercise.fromDoc(Map<String, dynamic> data, String id) {
    final t = data['targetMuscles'];
    final target = (t is List) ? t.join(', ') : (t ?? '').toString();

    return Exercise(
      id: id,
      name: (data['name'] ?? id).toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      level: (data['level'] ?? '').toString(),
      targetMuscles: target,
      order: (data['order'] ?? 0) is int ? data['order'] : int.tryParse('${data['order']}') ?? 0,
      isActive: (data['isActive'] ?? true) as bool,
    );
  }
}
