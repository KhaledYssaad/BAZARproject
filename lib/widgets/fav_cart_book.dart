import 'package:app/auth/auth_service.dart';
import 'package:app/constants/colors.dart';
import 'package:app/home/categoryscreen/specific_book.dart';
import 'package:flutter/material.dart';

class FavCartBook extends StatefulWidget {
  final Map<String, dynamic> book;
  final bool isCart;

  const FavCartBook({super.key, required this.book, required this.isCart});

  @override
  State<FavCartBook> createState() => _FavCartBookState();
}

class _FavCartBookState extends State<FavCartBook> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    try {
      final authService = AuthService();
      final userId = authService.getCurrentUserId();
      if (userId == null) return;

      final user = await authService.getUserProfile(userId);
      if (user == null) return;

      if (user['favorites'] is List) {
        final favs = List<Map<String, dynamic>>.from(user['favorites']);
        final fav = favs.any((f) => f['title'] == widget.book['title']);
        setState(() => isFavorite = fav);
      }
    } catch (_) {}
  }

  Future<void> _toggleFavorite() async {
    try {
      final authService = AuthService();
      final userId = authService.getCurrentUserId();
      if (userId == null) return;

      final user = await authService.getUserProfile(userId);
      if (user == null) return;

      List<Map<String, dynamic>> favoritesData = [];
      if (user['favorites'] is List) {
        favoritesData = List<Map<String, dynamic>>.from(user['favorites']);
      }

      if (isFavorite) {
        favoritesData.removeWhere((f) => f['title'] == widget.book['title']);
      } else {
        favoritesData.add({
          "title": widget.book['title'] ?? '',
          "author": widget.book['author'] ?? '',
          "pic": widget.book['pic'] ?? ''
        });
      }

      await authService.updateProfile(favorites: favoritesData);

      setState(() => isFavorite = !isFavorite);
    } catch (_) {}
  }

  Future<void> _removeFromCart(String title) async {
    try {
      final authService = AuthService();
      final userId = authService.getCurrentUserId();
      if (userId == null) return;

      final user = await authService.getUserProfile(userId);
      if (user == null) return;

      List<Map<String, dynamic>> cartData = [];
      if (user['cart'] is List) {
        cartData = List<Map<String, dynamic>>.from(user['cart']);
      }

      cartData.removeWhere((f) => f['title'] == title);
      await authService.updateProfile(cart: cartData);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.book['title'] ?? 'No title';
    final author = widget.book['author'] ?? 'Unknown author';
    final pic = widget.book['pic'] ?? '';

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => BookDetailBottomSheet(
            title: title,
            bookCoverUrl: pic,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.BordersGrey)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: pic.isNotEmpty
                  ? Image.network(
                      pic,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: AppColors.CustomRed,
                          size: 44),
                    )
                  : const Icon(Icons.broken_image,
                      color: AppColors.CustomRed, size: 44),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  author,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryPurple),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: AppColors.primaryPurple),
            ),
            if (widget.isCart)
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Remove from cart"),
                      content: const Text(
                          "Are you sure you want to remove this book from your cart?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(_, false),
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () => Navigator.pop(_, true),
                            child: const Text("Remove",
                                style: TextStyle(color: AppColors.CustomRed))),
                      ],
                    ),
                  );
                  if (confirm == true) _removeFromCart(title);
                },
                icon: const Icon(Icons.delete_rounded,
                    color: AppColors.CustomRed),
              ),
          ],
        ),
      ),
    );
  }
}
