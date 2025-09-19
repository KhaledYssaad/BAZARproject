import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  Session? _session;

  Session? get session => _session;

  /// ----------------------
  ///HNA TE3 L AUTHENTICATION
  /// ----------------------

  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    _session = res.session;
    return res;
  }

  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password, String userName) async {
    final res = await _supabase.auth.signUp(
        email: email, password: password, data: {"display_name": userName});
    _session = res.session;
    return res;
  }

  Future<UserResponse> linkPhoneToAccount(String phone) async {
    final res = await _supabase.auth.updateUser(UserAttributes(phone: phone));
    _session = _supabase.auth.currentSession;
    return res;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _session = null;
  }

  Future<void> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
    );
    _session = _supabase.auth.currentSession;
  }

  Future<void> signInWithApple() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.apple,
    );
    _session = _supabase.auth.currentSession;
  }

  ///HNA PROFILE HANDLING

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response =
        await _supabase.from('profile').select().eq('id', userId).maybeSingle();

    return response;
  }

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    return await getUserProfile(user.id);
  }

  Future<void> updateProfile({
    String? displayName,
    String? phone,
    String? address,
    String? profilePic,
    dynamic cart,
    dynamic favorites,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception("No logged in user");
    }

    final updates = {
      if (displayName != null) 'display_name': displayName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (profilePic != null) 'profile_pic': profilePic,
      if (cart != null) 'cart': cart,
      if (favorites != null) 'favorites': favorites,
    };

    if (updates.isNotEmpty) {
      await _supabase.from('profile').update(updates).eq('id', user.id);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final response = await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    if (response.user == null) {
      throw Exception("Password update failed: ${response}");
    }
  }

  Future<User?> verifyOtp({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    final res = await _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: type,
    );

    return res.user;
  }

  Future<String?> pickAndUploadProfilePic() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["jpg", "jpeg", "png"],
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      final fileName = file.name;

      if (kIsWeb) {
        final fileBytes = file.bytes;
        if (fileBytes == null) return null;

        await Supabase.instance.client.storage.from('avatars').uploadBinary(
            'public/$fileName', fileBytes,
            fileOptions: FileOptions(upsert: true));
      } else {
        final path = file.path;
        if (path == null) return null;

        final fileObj = File(path);
        await Supabase.instance.client.storage.from('avatars').upload(
            'public/$fileName', fileObj,
            fileOptions: FileOptions(upsert: true));
      }

      final url = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl('public/$fileName');
      return url;
    } catch (e) {
      debugPrint('Upload failed: $e');
      return null;
    }
  }

  User? getCurrentUser() => _supabase.auth.currentUser;
  String? getCurrentUserEmail() => _supabase.auth.currentUser?.email;
  String? getCurrentUserId() => _supabase.auth.currentUser?.id;
}
