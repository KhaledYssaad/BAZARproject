import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class LibraryService {
  final String projectId = "exvg489e";
  final String dataset = "production";
  late final String baseUrl =
      "https://$projectId.api.sanity.io/v2023-05-03/data/query/$dataset";

  /// Search books by category or new
  Future<List<Book>> searchBooks(String query) async {
    if (query.toLowerCase() == "new" || query.isEmpty) {
      return _fetchAllBooks();
    } else {
      return _fetchByCategory(query);
    }
  }

  Future<List<Book>> searchBooksByTitle(String query) async {
    final groqQuery =
        '*[_type == "book" && title match "*$query*"]{title, author, publisher, price, desc, pages, rating, ratingCount, category, cover}';
    return _fetchWithQuery(groqQuery);
  }

  Future<List<Book>> _fetchAllBooks() async {
    final groqQuery =
        '*[_type == "book"]{title, author, publisher, price, desc, pages, rating, ratingCount, category, cover}';
    return _fetchWithQuery(groqQuery);
  }

  Future<List<Book>> _fetchByCategory(String category) async {
    final groqQuery =
        '*[_type == "book" && "$category" in category]{title, author, publisher, price, desc, pages, rating, ratingCount, category, cover}';
    return _fetchWithQuery(groqQuery);
  }

  Future<List<Book>> _fetchWithQuery(String groqQuery) async {
    final encodedQuery = Uri.encodeQueryComponent(groqQuery);
    final url = Uri.parse('$baseUrl?query=$encodedQuery');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch books: ${response.body}");
    }

    final data = json.decode(response.body);
    final results = data['result'] as List<dynamic>? ?? [];
    return results.map(_parseBook).toList();
  }

  Book _parseBook(dynamic doc) {
    final title = doc['title'] ?? '';
    final author = doc['author'] ?? '';
    final publisher = doc['publisher'] ?? '';
    final price = doc['price'] ?? '';
    final desc = doc['desc'] ?? '';
    final pages = doc['pages'] ?? '';
    final rating = doc['rating'] ?? '';
    final ratingCount = doc['ratingCount'] ?? '';
    final categories =
        (doc['category'] as List?)?.map((c) => c.toString()).toList() ?? [];

    String coverUrl = 'https://via.placeholder.com/150x200?text=No+Cover';
    if (doc['cover'] != null && doc['cover']['asset'] != null) {
      final ref = doc['cover']['asset']['_ref'];
      final parts = ref.split('-');
      if (parts.length >= 4) {
        coverUrl =
            "https://cdn.sanity.io/images/$projectId/$dataset/${parts[1]}-${parts[2]}.${parts[3]}";
      }
    }

    return Book(
      title: title,
      author: author,
      publisher: publisher,
      price: price,
      desc: desc,
      pages: pages,
      rating: rating,
      ratingCount: ratingCount,
      cover: coverUrl,
      categories: categories,
    );
  }
}
