// ملف جديد: lib/utils/id_generator.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SmartIdGenerator {
  static Future<String> generateNumericId({
    required String gymId,
    required String role,
  }) async {
    // الحصول على آخر رقم مستخدم
    final lastUser = await FirebaseFirestore.instance
        .collection('users')
        .where('gymId', isEqualTo: gymId)
        .where('role', isEqualTo: role)
        .orderBy('numericId', descending: true)
        .limit(1)
        .get();

    int nextSequence = 1;

    if (lastUser.docs.isNotEmpty) {
      final lastId = lastUser.docs.first['numericId'] as String;
      // استخراج التسلسل من آخر ID
      final currentSequence = int.tryParse(lastId.substring(5)) ?? 0;
      nextSequence = currentSequence + 1;
    }

    // الحصول على gymCode من النادي
    final gymDoc = await FirebaseFirestore.instance
        .collection('gyms')
        .doc(gymId)
        .get();

    final gymCode = gymDoc['gymCode']?.toString() ?? '1001';

    // Role code
    String roleCode = '1'; // owner
    if (role == 'coach') roleCode = '2';
    if (role == 'player') roleCode = '3';

    // توليد ID بالشكل: gymCode + roleCode + sequence (5 أرقام)
    return '$gymCode$roleCode${nextSequence.toString().padLeft(5, '0')}';
  }

  static String getRoleName(String role) {
    switch (role) {
      case 'owner': return 'مدير';
      case 'coach': return 'مدرب';
      case 'player': return 'لاعب';
      default: return 'مستخدم';
    }
  }
}