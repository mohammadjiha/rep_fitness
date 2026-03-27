import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingPageModel {
  final String title;
  final String subtitle;
  final int order;
  OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.order,
  });
  factory OnboardingPageModel.fromMap(Map<String, dynamic> map) {
    return OnboardingPageModel(
      title: (map['title'] ?? '') as String,
      subtitle: (map['subtitle'] ?? '') as String,
      order: (map['order'] ?? 0) as int,
    );
  }
}
Future<List<OnboardingPageModel>> fetchOnboardingPages() async {
  final snap = await FirebaseFirestore.instance
      .collection('onboarding')
      .orderBy('order')
      .get();

  return snap.docs
      .map((d) => OnboardingPageModel.fromMap(d.data()))
      .where((p) => p.title.isNotEmpty && p.subtitle.isNotEmpty)
      .toList();
}