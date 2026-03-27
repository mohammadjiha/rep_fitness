import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../cache/chchehelper.dart';
import '../../../../core/constants/cachekey.dart' show CacheKeys;

class SignInController extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();

  bool rememberMe = false;
  bool loading = false;
  String? selectedGymName;

  Future<void> loadSavedData() async {
    final gymName = CacheHelper.getString(CacheKeys.selectedGymName);
    final savedRemember = CacheHelper.getBool(CacheKeys.rememberMe) ?? false;

    if (savedRemember) {
      emailController.text = CacheHelper.getString(CacheKeys.savedEmail) ?? '';
      passwordController.text =
          await _secureStorage.read(key: CacheKeys.savedPassword) ?? '';
    }

    selectedGymName = gymName;
    rememberMe = savedRemember;
    notifyListeners();
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }

  /// Returns null on success, or an error message string on failure.
  /// Calls [onNavigateToGymId] or [onNavigateToHome] for navigation.
  Future<String?> doLogin({
    required VoidCallback onNavigateToGymId,
    required VoidCallback onNavigateToHome,
  }) async {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      return 'Enter your email and password';
    }

    loading = true;
    notifyListeners();

    try {
      final selectedGymId = CacheHelper.getString(CacheKeys.selectedGymId);

      if (selectedGymId == null || selectedGymId.isEmpty) {
        onNavigateToGymId();
        return 'Please enter the gym code first.';
      }

      // 1) Firebase Auth login
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final uid = cred.user!.uid;

      // 2) Get user document
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        throw Exception('The account is not linked to any data in the system.');
      }

      final userData = userDoc.data()!;
      final userGymId = userData['gymId'] as String?;
      final userRole = (userData['role'] as String?) ?? 'player';
      final userNumericId = (userData['numericId']?.toString()) ?? 'Not set';

      // 3) Check gym link
      if (userGymId == null || userGymId.isEmpty) {
        await FirebaseAuth.instance.signOut();
        throw Exception('This account is not linked to any club.');
      }

      if (userGymId != selectedGymId) {
        await FirebaseAuth.instance.signOut();
        throw Exception('This account does not belong to the current club.');
      }

      // 4) Save user info
      await CacheHelper.setString(CacheKeys.userRole, userRole);
      await CacheHelper.setString(CacheKeys.userNumericId, userNumericId);
      await CacheHelper.setString(CacheKeys.userEmail, email);
      await CacheHelper.setString(
        CacheKeys.userName,
        (userData['fullName'] ?? 'User').toString(),
      );

      // 5) Remember me
      await CacheHelper.setBool(CacheKeys.rememberMe, rememberMe);

      if (rememberMe) {
        await CacheHelper.setString(CacheKeys.savedEmail, email);
        await _secureStorage.write(
          key: CacheKeys.savedPassword,
          value: passwordController.text,
        );
      } else {
        await CacheHelper.remove(CacheKeys.savedEmail);
        await _secureStorage.delete(key: CacheKeys.savedPassword);
      }

      onNavigateToHome();
      return null; // success
    } catch (e) {
      String msg = 'Login failed. Please try again.';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            msg = 'No user found for this email.';
            break;
          case 'wrong-password':
            msg = 'Incorrect password.';
            break;
          case 'invalid-email':
            msg = 'Invalid email address.';
            break;
          case 'network-request-failed':
            msg = 'Connection error. Check your internet connection.';
            break;
          case 'too-many-requests':
            msg = 'Too many attempts. Please try again later.';
            break;
          default:
            msg = e.message ?? msg;
        }
      } else if (e is Exception) {
        msg = e.toString().replaceAll('Exception: ', '');
      }

      return msg;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}