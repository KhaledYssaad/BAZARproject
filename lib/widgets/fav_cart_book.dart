import 'package:app/auth/auth_service.dart';
import 'package:app/constants/colors.dart';
import 'package:app/home/categoryscreen/specific_book.dart';
import 'package:flutter/material.dart';

class FavCartBook extends StatefulWidget {
  final dynamic book;
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
      String? id = authService.getCurrentUserId();
      if (id == null) return;

      final user = await authService.getUserProfile(id);
      if (user == null) return;

      if (user['favorites'] != null && user['favorites'] is List) {
        final favs = List<Map<String, dynamic>>.from(user['favorites']);
        final fav = favs.any((f) => f['title'] == widget.book['title']);
        setState(() {
          isFavorite = fav;
        });
      }
    } catch (e) {
    }
  }

  Future<void> _removeFromcart(String title) async {
    try {
      final authService = AuthService();
      String? id = authService.getCurrentUserId();
      if (id == null) throw Exception("No user logged in");

      final user = await authService.getUserProfile(id);
      if (user == null) throw Exception("User profile not found");

      List<dynamic> cartData = [];
      if (user['cart'] != null) {
        if (user['cart'] is List) {
          cartData = List.from(user['cart']);
        } else {
          throw Exception("Cart is not a valid JSON array");
        }
      }
      cartData.removeWhere((f) => f['title'] == title);

      await authService.updateProfile(cart: cartData);
    } catch (e) {
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      final authService = AuthService();
      String? id = authService.getCurrentUserId();
      if (id == null) return;

      final user = await authService.getUserProfile(id);
      if (user == null) return;

      List<dynamic> favoritesData = [];
      if (user['favorites'] != null && user['favorites'] is List) {
        favoritesData = List.from(user['favorites']);
      }

      if (isFavorite) {
        favoritesData.removeWhere((f) => f['title'] == widget.book['title']);
      } else {
        favoritesData.add({"title": widget.book['title']});
      }

      await authService.updateProfile(favorites: favoritesData);

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.BordersGrey,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.book["pic"],
                height: 48,
                width: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 44,
                  color: AppColors.CustomRed,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    widget.book["title"],
                    style: const TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.book["author"],
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.primaryPurple,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: AppColors.primaryPurple,
              ),
            ),
            widget.isCart
                ? IconButton(
                    onPressed: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Remove from cart"),
                          content: const Text(
                              "Are you sure you want to remove this book from your cart?"),
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
                                "Remove",
                                style: TextStyle(color: AppColors.CustomRed),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        _removeFromcart(widget.book["title"]);
                      }
                    },
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: AppColors.CustomRed,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => BookDetailBottomSheet(
            title: widget.book["title"],
            bookCoverUrl: widget.book["pic"],
          ),
        );
      },
    );
  }
}
