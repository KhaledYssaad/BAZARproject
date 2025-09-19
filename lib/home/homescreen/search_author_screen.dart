import 'package:flutter/material.dart';
import 'package:app/apiServices/author_service.dart';
import 'package:app/models/author_model.dart';
import 'package:app/widgets/author_bottom_sheet.dart';

class SearchAuthorScreen extends StatefulWidget {
  const SearchAuthorScreen({super.key});

  @override
  State<SearchAuthorScreen> createState() => _SearchAuthorScreenState();
}

class _SearchAuthorScreenState extends State<SearchAuthorScreen> {
  final authorService = AuthorService();
  Author? searchResult;
  bool isLoading = false;
  bool hasError = false;

  Future<void> _searchAuthor(String query) async {
    setState(() {
      isLoading = true;
      hasError = false;
      searchResult = null;
    });

    try {
      final author = await authorService.fetchAuthorByName(query);
      if (author == null) throw Exception("No author found");

      setState(() {
        searchResult = author;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Search Author",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Search Author",
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _searchAuthor(value.trim());
                }
              },
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (hasError)
              const Text("No author found",
                  style: TextStyle(color: Colors.red)),
            if (!isLoading && searchResult != null)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => AuthorDetailBottomSheet(
                      authorName: searchResult!.name,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(searchResult!.imageUrl),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              searchResult!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Top work: ${searchResult!.topWork}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
