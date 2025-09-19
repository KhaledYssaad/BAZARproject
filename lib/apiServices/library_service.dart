import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class LibraryService {
  static const String baseUrl = 'https://openlibrary.org';

  Future<List<Book>> searchBooks(String query) async {
    return _search(query, useTitle: false);
  }

  Future<List<Book>> searchBooksByTitle(String query) async {
    return _search(query, useTitle: true);
  }

  Future<List<Book>> _search(String query, {required bool useTitle}) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final url = Uri.parse(
      '$baseUrl/search.json?${useTitle ? 'title' : 'q'}=$encodedQuery',
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to search Open Library");
    }

    final data = json.decode(response.body);
    final docs = data['docs'] as List<dynamic>? ?? [];

    return docs.map(_parseBook).toList();
  }

  Book _parseBook(dynamic doc) {
    final title = doc['title'] ?? 'No Title';

    final authorsList = doc['author_name'];
    final author = (authorsList is List && authorsList.isNotEmpty)
        ? authorsList.first
        : 'Unknown';

    final coverId = doc['cover_i'];
    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
        : 'https://via.placeholder.com/150x200?text=No+Cover';

    final publisherField = doc['publisher'];
    final publisher = (publisherField is List && publisherField.isNotEmpty)
        ? publisherField.first
        : (publisherField is String ? publisherField : 'Unknown');

    String isbn = 'Unknown';
    if (doc['isbn_13'] != null && (doc['isbn_13'] as List).isNotEmpty) {
      isbn = doc['isbn_13'].first;
    } else if (doc['isbn'] != null && (doc['isbn'] as List).isNotEmpty) {
      isbn = doc['isbn'].first;
    }

    return Book(
      title: title,
      author: author,
      bookCoverUrl: coverUrl,
      publisher: publisher,
      isbn: isbn,
    );
  }
}
