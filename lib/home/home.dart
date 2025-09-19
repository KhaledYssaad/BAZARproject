// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app/auth/auth_service.dart';
import 'package:app/constants/colors.dart';
import 'package:app/home/cartscreen/cart_screen.dart';
import 'package:app/home/categoryscreen/category.dart';
import 'package:app/home/homescreen/home_screen.dart';
import 'package:app/home/profilescreen/profile_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
    });
  }

  int _selectedIndex = 0;

  List<Widget> get _screens => [
        HomeScreen(
          onSeeAll: () => setState(() => _selectedIndex = 1),
        ),
        CategoryPage(),
        CartScreen(),
        profile != null
            ? ProfileScreen(profile: profile)
            : const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
      ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.primaryGrey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list_rounded), label: "Category"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded), label: "Profile"),
        ],
      ),
    );
  }
}
