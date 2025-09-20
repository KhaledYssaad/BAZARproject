import 'package:app/apiServices/library_service.dart';
import 'package:app/home/categoryscreen/specific_book.dart';
import 'package:app/home/categoryscreen/book_style.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';
import 'package:app/models/book_model.dart';

class TopOfWeek extends StatefulWidget {
  final VoidCallback? onSeeAll;

  const TopOfWeek({super.key, this.onSeeAll});

  @override
  State<TopOfWeek> createState() => _TopOfWeekState();
}

class _TopOfWeekState extends State<TopOfWeek> {
  final LibraryService apiService = LibraryService();
  List<Book> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      final fetchedBooks = await apiService.searchBooks("");
      setState(() {
        books = fetchedBooks.take(8).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top of the Week",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (widget.onSeeAll != null) {
                    widget.onSeeAll!();
                  }
                },
                child: const Text(
                  "See All",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 199,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : books.isEmpty
                  ? Center(child: Text("No books found"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return GestureDetector(
                            child: Container(
                              width: 127,
                              margin:
                                  const EdgeInsets.only(right: 8, bottom: 8),
                              child: BookCoverWidget(
                                bookCoverUrl: book.cover,
                                title: book.title,
                                author: book.author,
                                width: 127,
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) => BookDetailBottomSheet(
                                  title: book.title,
                                ),
                              );
                            });
                      },
                    ),
        ),
      ],
    );
  }
}
