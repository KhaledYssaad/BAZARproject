import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';

class BookCoverWidget extends StatelessWidget {
  final String bookCoverUrl;
  final String title;
  final String author;
  final double width;
  final double height;

  const BookCoverWidget({
    Key? key,
    required this.bookCoverUrl,
    required this.title,
    required this.author,
    required this.width,
    this.height = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              bookCoverUrl,
              fit: BoxFit.cover,
              width: width,
              height: height,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.book,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title.isNotEmpty ? title : "No Title",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          author.isNotEmpty ? author : "Unknown",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPurple,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
