import 'package:flutter/foundation.dart';

class Book {
  final String title;
  final String author;
  final String publisher;
  final String price;
  final String desc;
  final String pages;
  final String rating;
  final String ratingCount;
  final String cover;
  final List<String> categories;
  Book(
      {required this.title,
      required this.author,
      required this.publisher,
      required this.price,
      required this.desc,
      required this.pages,
      required this.rating,
      required this.cover,
      required this.ratingCount,
      required this.categories});
}
