import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:FluRickandMorty/domain/entities/character.dart';

class CharacterApi {
  final String _baseUrl = 'rickandmortyapi.com';
  final String _characterUrl = '/api/character';
  final String _charactersJsonKey = 'results';

  final HttpClient _httpClient = HttpClient();

  Future<List<Character>> getCharacters() async {
    final uri = Uri.https(_baseUrl, _characterUrl);
    final response = await _getJson(uri);

    if (response == null || response[_charactersJsonKey] == null) {
      print('CharacterApi._getCharacters(): Error while retriving characters');
      return null;
    }

    return _convert(response[_charactersJsonKey]);
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final request = await _httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        print(
            'CharacterApi._getJson($uri) status code is ${response.statusCode}');
        return null;
      }
      final responseBody = await response.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('CharacterApi._getJson($uri) exception thrown $e');
      return null;
    }
  }

  List<Character> _convert(List charactersJson) {
    List<Character> characters = <Character>[];
    charactersJson.forEach((character) {
      characters.add(Character.fromJson(character));
    });
    return characters;
  }
}
