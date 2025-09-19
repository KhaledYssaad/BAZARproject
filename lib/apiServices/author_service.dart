import 'dart:convert';
import 'package:app/models/author_model.dart';
import 'package:http/http.dart' as http;

class AuthorService {
  Future<Author?> fetchAuthorByName(String? query) async {
    if (query == null || query.trim().isEmpty) return null;
    query = query.replaceAll(" ", "+");
    final encodedQuery = Uri.encodeQueryComponent(query.trim());
    final url = Uri.parse(
        'https://openlibrary.org/search/authors.json?q=$encodedQuery');
    final response = await http.get(url);

    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    final docs = data['docs'] as List<dynamic>? ?? [];

    if (docs.isEmpty) return null;

    final doc = docs.first;
    String role = 'Author';
    final olid = (doc['key'] as String).split('/').last;

    final detailUrl = Uri.parse('https://openlibrary.org/authors/$olid.json');
    final detailResponse = await http.get(detailUrl);

    String bio = 'No description available';
    if (detailResponse.statusCode == 200) {
      final detailData = json.decode(detailResponse.body);
      if (detailData['bio'] != null) {
        if (detailData['bio'] is String) {
          bio = detailData['bio'];
        } else if (detailData['bio'] is Map &&
            detailData['bio']['value'] != null) {
          bio = detailData['bio']['value'];
        }
      }
      if (detailData['subjects'] != null &&
          detailData['subjects'] is List &&
          (detailData['subjects'] as List).isNotEmpty) {
        role = (detailData['subjects'] as List).first.toString();
      }
    }

    final imageUrl = 'https://covers.openlibrary.org/a/olid/$olid-L.jpg';
    final ratingsSortable = (doc['ratings_sortable'] ?? 0.0).toDouble();

    return Author(
      name: doc['name'] ?? 'Unknown',
      olid: olid,
      topWork: doc['top_work'] ?? 'Unknown',
      birthDate: doc['birth_date'] ?? 'Unknown',
      deathDate: doc['death_date'] ?? 'Unknown',
      bio: bio,
      imageUrl: imageUrl,
      role: role,
      ratingsSortable: ratingsSortable,
    );
  }

  Future<List<Author>> fetchAuthors({
    int page = 1,
    double minRatingSortable = 3.0,
    int minWorks = 5,
  }) async {
    List<String> queries = ['j', "a", 'm', 'e', 'i', 'o', 'u', 's'];
    List<Author> authors = [];

    for (var q in queries) {
      final url = Uri.parse(
          'https://openlibrary.org/search/authors.json?q=${(q)}&page=$page');
      final response = await http.get(url);

      if (response.statusCode != 200) continue;

      final data = json.decode(response.body);
      final docs = data['docs'] as List<dynamic>? ?? [];

      final filteredDocs = docs.where((doc) {
        final workCount = doc['work_count'] ?? 0;
        final ratingSortable = (doc['ratings_sortable'] ?? 0.0) as double;
        return workCount >= minWorks && ratingSortable >= minRatingSortable;
      }).toList();

      authors.addAll(filteredDocs.map((doc) {
        final olid = (doc['key'] as String).split('/').last;
        final imageUrl = 'https://covers.openlibrary.org/a/olid/$olid-L.jpg';

        return Author(
          name: doc['name'] ?? 'Unknown',
          olid: olid,
          topWork: doc['top_work'] ?? 'Unknown',
          birthDate: doc['birth_date'] ?? 'Unknown',
          deathDate: doc['death_date'] ?? 'Unknown',
          bio: '',
          imageUrl: imageUrl,
          ratingsSortable: 0,
          role: 'Author',
        );
      }));
    }

    final uniqueAuthors = {for (var a in authors) a.olid: a}.values.toList();

    return uniqueAuthors;
  }
}
