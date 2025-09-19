import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/detailed_book.dart';

class BookDetailsService {
  static const String openLibBase = 'https://openlibrary.org';
  static const String googleBooksBase =
      'https://www.googleapis.com/books/v1/volumes';
  static const String apiKey = 'AIzaSyBOWHzFZTZ0SvG_zF_H2q6kcgNXbcO1-GM';

  Future<Book?> getBookDetailsByTitle(String title) async {
    final query = Uri.encodeQueryComponent(title);
    final url = Uri.parse('$googleBooksBase?q=$query&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    final items = data['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return null;

    final volumeInfo = items[0]['volumeInfo'] ?? {};
    final bookTitle = volumeInfo['title'] ?? 'No Title';
    final authors = (volumeInfo['authors'] as List<dynamic>?)?.join(', ') ??
        'Unknown Author';

    double avgRating = 0;
    int ratingCount = 0;

    final ratingData = await _fetchOpenLibraryRatings(bookTitle, authors);
    avgRating = ratingData['average'] ?? 0.0;
    ratingCount = ratingData['count'] ?? 0;

    if (ratingCount == 0) {
      avgRating = (volumeInfo['averageRating'] ?? 0).toDouble();
      ratingCount = (volumeInfo['ratingsCount'] ?? 0).toInt();
    }

    return Book(
      title: bookTitle,
      author: authors,
      publisher: volumeInfo['publisher'] ?? 'Unknown Publisher',
      price: 'N/A',
      desc: volumeInfo['description'] ?? 'No description available',
      pages: (volumeInfo['pageCount']?.toString()) ?? 'Unknown',
      rating: avgRating.toStringAsFixed(1),
      ratingCount: ratingCount.toString(),
    );
  }

  Future<Map<String, dynamic>> _fetchOpenLibraryRatings(
      String title, String author) async {
    try {
      final searchUrl = Uri.parse(
          '$openLibBase/search.json?title=${Uri.encodeQueryComponent(title)}&author=${Uri.encodeQueryComponent(author)}');
      final searchRes = await http.get(searchUrl);
      if (searchRes.statusCode != 200) return {};

      final searchData = json.decode(searchRes.body);
      final docs = searchData['docs'] as List<dynamic>? ?? [];
      if (docs.isEmpty) return {};

      final workKey = docs[0]['key'];
      final ratingsUrl = Uri.parse('$openLibBase$workKey/ratings.json');

      final ratingsRes = await http.get(ratingsUrl);
      if (ratingsRes.statusCode != 200) return {};

      final ratingsData = json.decode(ratingsRes.body);
      final summary = ratingsData['summary'];
      if (summary == null) return {};

      return {
        'average': (summary['average'] ?? 0.0).toDouble(),
        'count': (summary['count'] ?? 0).toInt(),
      };
    } catch (e) {
      return {};
    }
  }
}
