import 'package:app/apiServices/author_service.dart';
import 'package:app/widgets/stars.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';
import 'package:app/models/author_model.dart';
import 'package:readmore/readmore.dart';

class AuthorDetailBottomSheet extends StatefulWidget {
  final String authorName;

  const AuthorDetailBottomSheet({
    super.key,
    required this.authorName,
  });

  @override
  State<AuthorDetailBottomSheet> createState() =>
      _AuthorDetailBottomSheetState();
}

class _AuthorDetailBottomSheetState extends State<AuthorDetailBottomSheet> {
  Author? details;
  bool isLoading = true;
  bool hasError = false;
  final authorservice = AuthorService();

  @override
  void initState() {
    super.initState();
    _getAuthorDetails();
  }

  Future<void> _getAuthorDetails() async {
    try {
      final author = await authorservice.fetchAuthorByName(widget.authorName);
      if (author == null) throw Exception("Author not found");
      setState(() {
        details = author;
        isLoading = false;
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
    final double sheetHeight = MediaQuery.of(context).size.height * 0.75;

    return SafeArea(
      child: SizedBox(
          height: sheetHeight,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError || details == null
                  ? const Center(
                      child: Text(
                        "Error fetching author details",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          SizedBox(height: 8),
                          CircleAvatar(
                            radius: 62,
                            backgroundImage: NetworkImage(details!.imageUrl),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details!.role,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details!.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stars(
                                  rating: details!.ratingsSortable.toString()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "About",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ReadMoreText(
                              details!.bio,
                              trimLines: 3,
                              colorClickableText: AppColors.primaryPurple,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: " Read more",
                              trimExpandedText: " Read less",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Top Product",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              details!.topWork,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
    );
  }
}
