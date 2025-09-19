import 'package:app/apiServices/author_service.dart';
import 'package:app/models/author_model.dart';
import 'package:app/widgets/author_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';

class Authors extends StatefulWidget {
  const Authors({super.key});

  @override
  State<Authors> createState() => _AuthorsState();
}

class _AuthorsState extends State<Authors> {
  final authorService = AuthorService();
  List<Author> authors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchauthors();
  }

  Future<void> _fetchauthors() async {
    try {
      final fetchedAuthors = await authorService.fetchAuthors();
      setState(() {
        authors = fetchedAuthors.take(8).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
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
                "Authors",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/home/seeauthors");
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
          height: 165,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : authors.isEmpty
                  ? Center(child: Text("No authors found"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: authors.length,
                      itemBuilder: (context, index) {
                        final author = authors[index];
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
                              builder: (context) => AuthorDetailBottomSheet(
                                authorName: author.name,
                              ),
                            );
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 8),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 51,
                                  backgroundImage:
                                      NetworkImage(author.imageUrl),
                                  backgroundColor: Colors.grey[200],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  author.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    height: 1.5,
                                    letterSpacing: 0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  author.role,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.5,
                                    color: AppColors.primaryGrey,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
