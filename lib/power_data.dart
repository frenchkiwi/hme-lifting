import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int?> fetchLifterId({
  required String firstName,
  required String lastName,
  required DateTime birthDate,
}) async {
  final url = Uri.https('www.openpowerlifting.org', '/api/v1/lifters', {
    'first_name': firstName,
    'last_name': lastName,
  });
  print('fetching user with first_name=$firstName and last_name=$lastName from request $url');

  final response = await http.get(url);

  if (response.statusCode != 200) {
    print('Failed to load lifters: ${response.statusCode}');
    return null;
  }

  final List<dynamic> data = jsonDecode(response.body);
  if (data.isEmpty) {
    print('No lifter found');
    return null;
  }

  // Just pick the first one for now, or improve by matching exact details
  final lifter = data[0];
  return lifter['id'] as int?;
}