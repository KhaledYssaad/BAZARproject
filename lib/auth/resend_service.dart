import 'dart:convert';
import 'package:http/http.dart' as http;

class ResendService {
  final String apiKey;

  ResendService(this.apiKey);

  final String _baseUrl = "https://api.resend.com/emails";

  Future<void> sendEmail({
    required String to,
    required String subject,
    required String html,
    String from = "no-reply@yourdomain.com",
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "from": from,
        "to": to,
        "subject": subject,
        "html": html,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to send email: ${response.statusCode} - ${response.body}",
      );
    }
  }

  Future<String> sendConfirmationCode({
    required String to,
    String from = "no-reply@yourdomain.com",
  }) async {
    final code =
        (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();

    const subject = "Your confirmation code";
    final html = "<p>Your confirmation code is: <strong>$code</strong></p>";

    await sendEmail(
      to: to,
      subject: subject,
      html: html,
      from: from,
    );

    return code;
  }
}
