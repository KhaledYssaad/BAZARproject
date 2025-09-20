import 'package:app/models/book_model.dart';
import 'package:app/apiServices/library_service.dart';
import 'package:app/home/categoryscreen/book_style.dart';
import 'package:app/home/categoryscreen/specific_book.dart';
import 'package:app/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String selectedCategory = "All";
  final LibraryService apiService = LibraryService();
  List<Book> books = [];
  bool isLoading = true;

  final List<String> categories = [
    "All",
    "Fantasy",
    "Adventure",
    "Young Adult",
    "Romance",
    "Self-Help",
    "Science",
    "Mystery",
    "History",
    "Biography"
  ];

  @override
  void initState() {
    super.initState();
    _fetchBooks("new");
  }

  Future<void> _fetchBooks(String category) async {
    try {
      final fetchedBooks =
          await apiService.searchBooks(category == "All" ? "new" : category);
      setState(() {
        books = fetchedBooks.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching books: $e")));
    }
  }

  void _tosearch() {
    Navigator.pushNamed(context, "/category/search");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: const Text(
            "Categories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: _tosearch,
            icon: const Icon(Icons.search_rounded, color: Colors.black),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: NotificationButton(),
            ),
          ],
          toolbarHeight: 60,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 28,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category == selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                            isLoading = true;
                          });
                          _fetchBooks(selectedCategory);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                fontFamily: "Open Sans",
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.primaryGrey,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  height: MediaQuery.of(context).size.height,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : books.isEmpty
                          ? const Center(child: Text("No books found"))
                          : GridView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: books.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisExtent: 210,
                              ),
                              itemBuilder: (context, index) {
                                final book = books[index];
                                final screenWidth =
                                    MediaQuery.of(context).size.width;
                                final itemWidth =
                                    (screenWidth - 24 * 2 - 16) / 2;

                                return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (context) =>
                                          BookDetailBottomSheet(
                                        title: book.title,
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: itemWidth,
                                    child: BookCoverWidget(
                                      bookCoverUrl: book.cover,
                                      title: book.title,
                                      author: book.author,
                                      width: itemWidth,
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ));
  }
}
