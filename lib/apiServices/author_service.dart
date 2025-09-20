import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/author_model.dart';

class AuthorService {
  final String baseUrl =
      "https://exvg489e.api.sanity.io/v2023-05-03/data/query/production";

  Future<List<Author>> fetchAuthors({String? nameQuery}) async {
    final query = nameQuery == null || nameQuery.isEmpty
        ? '*[_type == "author"]{name, topWork, birthDate, deathDate, bio, role, ratingsSortable, imageUrl}'
        : '*[_type == "author" && name match "*$nameQuery*"]{name, topWork, birthDate, deathDate, bio, role, ratingsSortable, imageUrl}';

    final encodedQuery = Uri.encodeQueryComponent(query);
    final url = Uri.parse('$baseUrl?query=$encodedQuery');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch authors: ${response.body}");
    }

    final data = json.decode(response.body);
    final results = data['result'] as List<dynamic>? ?? [];

    return results.map(_parseAuthor).toList();
  }

  String normalize(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[\s\.]'), '');

  Future<Author?> fetchAuthorByName(String name) async {
    final normalizedQuery = normalize(name);
    final authors = await fetchAuthors();

    return authors.firstWhere(
      (author) => normalize(author.name) == normalizedQuery,
    );
  }

  Author _parseAuthor(dynamic doc) {
    String imageUrl = 'https://via.placeholder.com/150x200?text=No+Image';
    final imageField = doc['imageUrl'];

    if (imageField != null &&
        imageField is Map &&
        imageField['asset'] != null &&
        imageField['asset']['_ref'] != null) {
      final ref = imageField['asset']['_ref'] as String;
      final parts = ref.split('-');
      if (parts.length >= 4) {
        final imageId = parts[1];
        final dimensions = parts[2];
        final ext = parts[3];
        imageUrl =
            'https://cdn.sanity.io/images/exvg489e/production/$imageId-$dimensions.$ext';
      }
    }

    return Author(
      name: doc['name'] ?? 'Unknown',
      topWork: doc['topWork'] ?? 'Unknown',
      birthDate: doc['birthDate'] ?? '',
      deathDate: doc['deathDate'] ?? '',
      bio: doc['bio'] ?? '',
      imageUrl: imageUrl,
      role: doc['role'] ?? 'Author',
      ratingsSortable: (doc['ratingsSortable'] ?? 0.0).toDouble(),
    );
  }
}
