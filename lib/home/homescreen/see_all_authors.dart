import "package:app/apiServices/author_service.dart";
import "package:app/models/author_model.dart";
import "package:app/widgets/author_bottom_sheet.dart";
import "package:app/widgets/notification.dart";
import "package:flutter/material.dart";

class SeeAllAuthors extends StatefulWidget {
  const SeeAllAuthors({super.key});

  @override
  State<SeeAllAuthors> createState() => _SeeAllAuthorsState();
}

class _SeeAllAuthorsState extends State<SeeAllAuthors> {
  final authorservice = AuthorService();
  List<Author> authors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAuthors();
  }

  Future<void> _fetchAuthors() async {
    try {
      final fetchedAuthors = await authorservice.fetchAuthors();
      setState(() {
        authors = fetchedAuthors.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _tosearch() {
    Navigator.pushNamed(context, "/author/searchauthors");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          "Authors",
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
      body: isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(child: CircularProgressIndicator()),
            )
          : authors.isEmpty
              ? const Center(child: Text("No authors found"))
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                    authorName: author.name));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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
                                  backgroundImage:
                                      NetworkImage(author.imageUrl),
                                  backgroundColor: Colors.grey[200],
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: screenWidth * 0.7 - 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        author.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: "Open Sans",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Top work: ${author.topWork}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: "Open Sans",
                                          fontWeight: FontWeight.w400,
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
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
