import 'package:app/apiServices/notification_service.dart';
import 'package:app/auth/auth_service.dart';
import 'package:app/constants/colors.dart';
import 'package:app/home/profilescreen/user_info_input.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? profile;
  bool isLoading = true;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _email;
  var _profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = _authService.getCurrentUser();
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final data = await _authService.getUserProfile(user.id);
    setState(() {
      profile = data ?? {};
      isLoading = false;
      _nameController.text = profile?['display_name'] ?? '';
      _phoneController.text = profile?['phone'] ?? '';
      _email = user.email ?? '';
    });
  }

  Future<void> _changeProfilePicture() async {
    try {
      final result = await _authService.pickAndUploadProfilePic();
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("No image selected"),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.CustomRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }
      setState(() {
        _profilePicUrl = result;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Profile picture updated successfully!"),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update profile picture: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: "Retry",
              textColor: Colors.white,
              onPressed: () => _changeProfilePicture(),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profilePic = profile?['profile_pic'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, {
              "display_name": _nameController.text,
              "phone": _phoneController.text,
              "profile_pic": _profilePicUrl.isNotEmpty
                  ? _profilePicUrl
                  : profile?['profile_pic'],
            });
          },
        ),
        title: const Text(
          'My Account',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Open Sans",
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profilePic != null
                          ? NetworkImage(profilePic)
                          : const AssetImage("assets/images/Google.png")
                              as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    TextButton(
                      onPressed: _changeProfilePicture,
                      child: const Text(
                        "Change Picture",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UserInfoInput(controller: _nameController, label: "Name"),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(235, 12, 12, 68),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: _email),
                    readOnly: true,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                      letterSpacing: 0,
                      color: Colors.black54,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            UserInfoInput(controller: _phoneController, label: "Phone"),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _authService.updateProfile(
                        profilePic:
                            _profilePicUrl.isNotEmpty ? _profilePicUrl : null,
                        displayName: _nameController.text,
                        phone: _phoneController.text.isNotEmpty
                            ? _phoneController.text
                            : null);
                    if (_phoneController.text.isNotEmpty) {
                      await _authService
                          .linkPhoneToAccount(_phoneController.text);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Account updated successfully"),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("update feild try again"),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.CustomRed,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: AppColors.primaryPurple,
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await AuthService().sendPasswordResetEmail(_email!);
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Check Your Email"),
                        content: Text("We've sent a reset token to your email. "
                            "Please check your inbox and use the token to reset your password."),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(context,
                                    "/login/forgotpassword/newpassword",
                                    arguments: {
                                      "account": true,
                                      "email": _email,
                                    });
                              },
                              child: Text("Continue"))
                        ],
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Could not send password reset email. Please try again.",
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.CustomRed,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: AppColors.primaryPurple,
                ),
                child: const Text(
                  "Change Password",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
