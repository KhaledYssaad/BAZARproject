import 'package:app/auth/auth_service.dart';
import 'package:app/widgets/fav_cart_book.dart';
import 'package:app/widgets/notification.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isLoading = true;

  Future<List<dynamic>> _fetchFavoriteBooks() async {
    try {
      final authService = AuthService();
      String? id = authService.getCurrentUserId();
      if (id == null) throw Exception("No user logged in");

      final user = await authService.getUserProfile(id);
      if (user == null) throw Exception("User profile not found");

      List<dynamic> favoriteData = [];
      if (user['favorites'] != null) {
        if (user['favorites'] is List) {
          favoriteData = List.from(user['favorites']);
        } else {
          throw Exception("favorite is not a valid JSON array");
        }
      }
      return favoriteData;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: Stack(
            alignment: Alignment.center,
            children: const [
              Center(
                child: Text(
                  "My Favorites",
                  style: TextStyle(
                    fontFamily: "Open Sans",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: NotificationButton(),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchFavoriteBooks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error fetching book details",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.heart_broken, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Go add some books!!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final books = snapshot.data as List<dynamic>;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    for (var book in books)
                      FavCartBook(
                        book: book,
                        isCart: false,
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
