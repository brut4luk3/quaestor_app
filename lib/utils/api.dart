import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

class Api {
  var main_url = "https://servicodados.ibge.gov.br/api/v2";

  Future<List> fetchNames() async {
    final url = '$main_url/censos/nomes/';

    final ioc = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final httpClient = IOClient(ioc);

    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load names');
    }
  }

  List<dynamic> searchNames(String query, List<dynamic> names) {
    if (query.isEmpty) {
      return names;
    } else {
      return names.where((name) {
        return name['nome'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<Map<String, dynamic>> fetchNameDetails(String selectedName) async {
    final url = '$main_url/censos/nomes/$selectedName';

    final ioc = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    final httpClient = IOClient(ioc);

    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data.isNotEmpty ? data[0] : {};
    } else {
      throw Exception('Failed to load name details');
    }
  }
}