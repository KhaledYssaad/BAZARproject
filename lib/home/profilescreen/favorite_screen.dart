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
  late Future<List<Map<String, dynamic>>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _fetchFavoriteBooks();
  }

  Future<List<Map<String, dynamic>>> _fetchFavoriteBooks() async {
    try {
      final authService = AuthService();
      final userId = authService.getCurrentUserId();
      if (userId == null) return [];

      final user = await authService.getUserProfile(userId);
      if (user == null || user['favorites'] == null) return [];

      if (user['favorites'] is List) {
        return List<Map<String, dynamic>>.from(user['favorites']);
      }

      return [];
    } catch (_) {
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
          automaticallyImplyLeading: false,
          title: Stack(
            alignment: Alignment.center,
            children: const [
              Center(
                  child: Text("My Favorites",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black))),
              Positioned(right: 0, child: NotificationButton()),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text("Error fetching favorites",
                    style: TextStyle(color: Colors.red)));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.heart_broken, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Go add some books!!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54)),
                ],
              ),
            );
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: books.length,
              itemBuilder: (_, index) =>
                  FavCartBook(book: books[index], isCart: false),
            );
          }
        },
      ),
    );
  }
}
