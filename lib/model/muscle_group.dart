class MuscleGroup {
  final String id;
  final bool isActive;
  final String name;
  final int order;
  MuscleGroup({ required this.isActive, required this.name, required this.order, required this.id});
  factory MuscleGroup.fromDoc(Map<String, dynamic> data, String id) {
    return MuscleGroup(
      id: id,
      name: (data['name'] ?? '').toString(),
      order: (data['order'] ?? 0) is int ? data['order'] : int.tryParse('${data['order']}') ?? 0,
      isActive: (data['isActive'] ?? true) as bool,
    );
  }

}