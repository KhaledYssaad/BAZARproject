import 'package:app/apiServices/notification_service.dart';
import 'package:app/auth/auth_service.dart';
import 'package:app/widgets/author_bottom_sheet.dart';
import 'package:app/widgets/stars.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';
import 'package:app/apiServices/book_details_service.dart';
import 'package:app/models/detailed_book.dart';
import 'package:readmore/readmore.dart';

class BookDetailBottomSheet extends StatefulWidget {
  final String title;
  final String bookCoverUrl;

  const BookDetailBottomSheet(
      {super.key, required this.title, required this.bookCoverUrl});

  @override
  State<BookDetailBottomSheet> createState() => _BookDetailBottomSheetState();
}

class _BookDetailBottomSheetState extends State<BookDetailBottomSheet> {
  final bookDetailsService = BookDetailsService();
  Book? details;
  bool isLoading = true;
  bool hasError = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _getBookDetails();
  }

  List<Widget> stars(double rating) {
    int filledStars = rating.floor();
    int totalStars = 5;
    return List.generate(totalStars, (index) {
      if (index < filledStars) {
        return const Icon(Icons.star_rounded, color: Colors.amber, size: 24);
      } else {
        return const Icon(Icons.star_rounded,
            color: Color.fromRGBO(18, 18, 18, 1), size: 24);
      }
    });
  }

  Future<void> _addToCart(String title, String pic, String author) async {
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

      final newBook = {
        "title": title,
        "pic": pic,
        "author": author,
      };

      cartData.add(newBook);
      await authService.updateProfile(cart: cartData);
      showNotification(
        id: 12,
        title: "Book Added to Cart",
        body: "\"$title\" has been added to your cart.",
      );
    } catch (e) {
      showNotification(
        id: 13,
        title: "Add to Cart Failed",
        body: "We couldn’t add \"$title\" to your cart. Please try again.",
      );
    }
  }

  Future<bool> _checkIfFavorite(String title) async {
    try {
      final authService = AuthService();
      String? id = authService.getCurrentUserId();
      if (id == null) return false;

      final user = await authService.getUserProfile(id);
      if (user == null) return false;

      if (user['favorites'] != null && user['favorites'] is List) {
        final favs = List<Map<String, dynamic>>.from(user['favorites']);
        return favs.any((f) => f['title'] == title);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _toggleFavorites(bool favorite, Book book) async {
    try {
      final authService = AuthService();
      final userId = authService.getCurrentUserId();
      if (userId == null) throw Exception("No user logged in");

      final user = await authService.getUserProfile(userId);
      if (user == null) throw Exception("User profile not found");

      List<Map<String, dynamic>> favoritesData = [];
      if (user['favorites'] is List) {
        favoritesData = List<Map<String, dynamic>>.from(user['favorites']);
      }

      if (favorite) {
        bool alreadyExists = favoritesData.any((f) => f['title'] == book.title);
        if (!alreadyExists) {
          favoritesData.add({
            "title": book.title,
            "author": book.author,
            "pic": widget.bookCoverUrl,
          });
          await authService.updateProfile(favorites: favoritesData);
          showNotification(
            id: 14,
            title: "Added to Favorites",
            body: "\"${book.title}\" has been added to your favorites.",
          );
        }
      } else {
        favoritesData.removeWhere((f) => f['title'] == book.title);
        await authService.updateProfile(favorites: favoritesData);
        showNotification(
          id: 15,
          title: "Removed from Favorites",
          body: "\"${book.title}\" has been removed from your favorites.",
        );
      }

      setState(() {
        isFavorite = favorite;
      });
    } catch (e) {
      showNotification(
        id: 16,
        title: "Favorites Update Failed",
        body: "We couldn’t update your favorites list. Please try again.",
      );
    }
  }

  Future<void> _getBookDetails() async {
    try {
      final fetchedBook =
          await bookDetailsService.getBookDetailsByTitle(widget.title);
      if (fetchedBook == null) throw Exception("Book not found");

      final fav = await _checkIfFavorite(fetchedBook.title);

      setState(() {
        details = fetchedBook;
        isLoading = false;
        isFavorite = fav;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.93;

    return SafeArea(
      child: SizedBox(
        height: sheetHeight,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError || details == null
                ? const Center(
                    child: Text(
                      "Error fetching book details",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      left: 16,
                      right: 16,
                      top: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.bookCoverUrl,
                              height: 313,
                              width: 237,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                details!.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Open Sans",
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                                _toggleFavorites(isFavorite, details!);
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: AppColors.primaryPurple,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "by: ",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                          builder: (context) =>
                                              AuthorDetailBottomSheet(
                                            authorName: details!.author,
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        padding: WidgetStateProperty.all(
                                            EdgeInsets.zero),
                                        minimumSize:
                                            WidgetStateProperty.all(Size.zero),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      child: Text(
                                        details!.author,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "And: ${details!.publisher}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ReadMoreText(
                          details!.desc,
                          trimLines: 3,
                          colorClickableText: AppColors.primaryPurple,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: " Read more",
                          trimExpandedText: " Read less",
                          style: const TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Review",
                              style: TextStyle(
                                fontFamily: "Open Sans",
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Stars(rating: details!.rating),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "People rated this: ${details!.ratingCount}",
                          style: const TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            height: 1.4,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                AppColors.primaryPurple),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48),
                              ),
                            ),
                            minimumSize: WidgetStateProperty.all(
                                const Size(double.infinity, 48)),
                          ),
                          onPressed: () {
                            _addToCart(details!.title, widget.bookCoverUrl,
                                details!.author);
                            Navigator.of(context).pop({});
                          },
                          child: const Text(
                            "Add to Cart",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 1.4,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
