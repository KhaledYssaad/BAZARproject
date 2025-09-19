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

  @override
  void initState() {
    super.initState();
    _fetchBooks("new");
  }

  Future<void> _fetchBooks(String category) async {
    try {
      final fetchedBooks = await apiService.searchBooks(category);

      setState(() {
        books = fetchedBooks.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _tosearch() {
    Navigator.pushNamed(context, "/category/search");
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "All",
      "Novels",
      "Self Love",
      "Science",
      "Romantic",
      "Fantasy",
      "Adventure",
      "Mystery",
      "History",
      "Biography"
    ];
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _tosearch,
                    icon: const Icon(Icons.search_rounded, color: Colors.black),
                  ),
                  const Text(
                    "Category",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  NotificationButton()
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
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
                          _fetchBooks(selectedCategory == "All"
                              ? "new"
                              : selectedCategory);
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
                  padding: EdgeInsets.symmetric(vertical: 16),
                  height: MediaQuery.of(context).size.height,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : books.isEmpty
                          ? Center(child: Text("No books found"))
                          : GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: books.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisExtent: 210,
                                childAspectRatio: 1,
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
                                        bookCoverUrl: book.bookCoverUrl,
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: itemWidth,
                                    child: BookCoverWidget(
                                      bookCoverUrl: book.bookCoverUrl,
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
