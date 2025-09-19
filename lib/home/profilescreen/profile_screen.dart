import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/auth/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.profile});
  final Map<String, dynamic>? profile;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profile;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "icon": Icons.person,
        "text": "My Account",
        "route": "/home/profile/account"
      },
      {
        "icon": Icons.location_on,
        "text": "Address",
        "route": "/home/profile/address"
      },
      {
        "icon": Icons.favorite,
        "text": "Favorites",
        "route": "/home/profile/favorites"
      },
      {
        "icon": Icons.shopping_cart,
        "text": "Cart",
        "route": "/home/profile/cart"
      },
      {
        "icon": Icons.help,
        "text": "Help Center",
        "route": "/home/profile/help"
      },
    ];

    final displayName = profile?['display_name'] ?? "User Name";
    final phone = profile?['phone'] ?? "No phone";
    final profilePic = profile?['profile_pic'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: const Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            height: 88,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.BordersGrey, width: 1),
                bottom: BorderSide(color: AppColors.BordersGrey, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: profilePic != null
                        ? Image.network(
                            profilePic,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/Google.png",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontFamily: "Open Sans",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(false), // Cancel
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(true), // Confirm
                            child: const Text(
                              "Logout",
                              style: TextStyle(color: AppColors.CustomRed),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      _logout();
                    }
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.CustomRed,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () async {
                    final updatedProfile = await Navigator.pushNamed(
                      context,
                      item["route"] as String,
                    );
                    if (updatedProfile != null && mounted) {
                      setState(() {
                        profile = updatedProfile as Map<String, dynamic>;
                      });
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Container(
                    height: 72,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryPurple10,
                          ),
                          child: Icon(
                            item["icon"] as IconData,
                            color: AppColors.primaryPurple,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          item["text"] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.primaryGrey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
